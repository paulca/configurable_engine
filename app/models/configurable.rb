class Configurable < ActiveRecord::Base

  after_save :invalidate_cache

  validates_presence_of    :name
  validates_uniqueness_of  :name

  validate :type_of_value

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
      create(:name => key.to_s, :value => value)
    end
  end

  def self.[](key)
    return self.defaults[key][:default] unless table_exists?

    value = Rails.cache.fetch("configurable_engine:#{key}") {
      find_by_name(key).try(:value)
    }

    value ||= self.defaults[key][:default]
    case self.defaults[key][:type]
    when 'boolean'
      [true, 1, "1", "t", "true"].include?(value)
    when 'decimal'
      BigDecimal.new(value.to_s)
    when 'integer'
      value.to_i
    when 'list'
      return value if value.is_a?(Array)
      value.split("\n").collect{ |v| v.split(',') }
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
    case Configurable.defaults[name][:type]
    when 'boolean'
      [true, 1, "1", "true", false, 0, "0", "false"].include?(value)
    when 'decimal'
      Float(value) rescue errors.add(:value, I18n.t("activerecord.errors.messages.invalid"))
    when 'integer'
      Integer(value) rescue errors.add(:value, I18n.t("activerecord.errors.messages.invalid"))
    when 'list'
      value.is_a?(Array) rescue errors.add(:value, I18n.t("activerecord.errors.messages.invalid"))
    end
  end

  def invalidate_cache
    Rails.cache.delete("configurable_engine:#{self.name}")
  end
end
