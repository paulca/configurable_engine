class Configurable < ActiveRecord::Base

  after_save :invalidate_cache, if: -> { ConfigurableEngine::Engine.config.use_cache }

  validates_presence_of    :name
  validates_uniqueness_of  :name

  validate :type_of_value
  before_save :serialize_value

  def self.defaults
    @defaults ||= HashWithIndifferentAccess.new(
      YAML.load_file(
        Rails.root.join('config', 'configurable.yml')
      )
    )
  end

  def self.keys
    self.defaults.collect { |k,v| k.to_s }.sort
  end

  def self.[]=(key, value)
    exisiting = find_by_name(key)
    if exisiting
      exisiting.update_attribute(:value, value)
    else
      create {|c| c.name = key.to_s; c.value = value}
    end
  end

  def self.[](key)
    return parse_value key, defaults[key][:default] unless table_exists?

    val = if ConfigurableEngine::Engine.config.use_cache
      Rails.cache.fetch("configurable_engine:#{key}") {
        find_by_name(key).try(:value)
      }
    else
      find_by_name(key).try(:value)
    end

    val ||= parse_value key, defaults[key][:default]
  end

  def value
    self.class.parse_value name, super
  end

  def self.parse_value key, value
    case defaults[key][:type]
    when 'boolean'
      [true, 1, "1", "t", "true"].include?(value)
    when 'decimal'
      value ||= 0
      BigDecimal.new(value.to_s)
    when 'integer'
      value.to_i
    when 'list'
      value ||= []
      if value.is_a? Array
        value
      else
        value.split("\n").collect { |v| v =~ ',' ? v.split(',') : v }
      end
    else
      value
    end
  end

  def self.method_missing(name, *args)
    name_stripped = name.to_s.sub(/[\?=]$/, '')
    if self.keys.include?(name_stripped)
      if name.to_s.end_with?('=')
        self[name_stripped] = args.first
      else
        self[name_stripped]
      end
    else
      super
    end
  end

  private

  def type_of_value
    return unless name
    valid = case Configurable.defaults[name][:type]
    when 'boolean'
      [true, 1, "1", "true", false, 0, "0", "false"].include?(value)
    when 'decimal'
      BigDecimal(value) rescue false
    when 'integer'
      Integer(value) rescue false
    when 'list'
      value.is_a?(Array)
    else
      true
    end
    errors.add(:value, I18n.t("activerecord.errors.messages.invalid")) unless valid
  end

  def serialize_value
    case Configurable.defaults[name][:type]
    when 'list'
      if value.is_a? Array
        if value.all? {|entry| entry.is_a? Array}
          self.value = value.collect {|a| a.join(',')}
        end
        self.value = value.join("\n")
      end
    end
  end

  def invalidate_cache
    Rails.cache.delete("configurable_engine:#{self.name}")
  end
end
