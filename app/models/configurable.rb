# frozen_string_literal: true

class Configurable < ActiveRecord::Base
  after_save    :invalidate_cache, if: -> { ConfigurableEngine::Engine.config.use_cache }
  after_destroy :invalidate_cache, if: -> { ConfigurableEngine::Engine.config.use_cache }

  validates :name, presence: true, uniqueness: { case_sensitive: true }

  validate :type_of_value

  def self.defaults
    @defaults ||= HashWithIndifferentAccess.new(
      YAML.load_file(
        Rails.root.join('config', 'configurable.yml')
      )
    )
  end

  def self.keys
    defaults.collect { |k, _v| k.to_s }.sort
  end

  def self.[]=(key, value)
    exisiting = find_by_name(key)
    if exisiting
      exisiting.update_attribute(:value, value)
    else
      create do |c|
        c.name = key.to_s
        c.value = Configurable.value_for_serialization key, value
      end
    end
  end

  def self.cache_key(key)
    "configurable_engine:#{key}"
  end

  def self.[](key)
    return parse_value key, defaults[key][:default] unless table_exists?

    value = false
    found = false
    database_finder = lambda do
      config = find_by_name(key)
      found = !config.nil?
      value = config.try(:value)
    end

    if ConfigurableEngine::Engine.config.use_cache
      found = Rails.cache.exist?(cache_key(key))
      if found
        value = Rails.cache.fetch(cache_key(key))
      else
        database_finder.call
        Rails.cache.write cache_key(key), value if found
      end
    else
      database_finder.call
    end

    if found
      value
    else
      parse_value(key, defaults[key][:default]).tap do |val|
        Rails.cache.write cache_key(key), val if ConfigurableEngine::Engine.config.use_cache
      end
    end
  end

  def value
    self.class.parse_value name, super
  end

  def self.parse_value(key, value)
    case defaults[key][:type]
    when 'boolean'
      [true, 1, '1', 't', 'true'].include?(value)
    when 'decimal'
      value ||= 0
      BigDecimal(value.to_s)
    when 'integer'
      value.to_i
    when 'list'
      value ||= []
      if value.is_a? Array
        value
      else
        value.split("\n").collect { |v| v =~ /,/ ? v.split(',') : v }
      end
    when 'date'
      if value.is_a? Date
        value
      elsif value.present?
        Date.parse(value)
      end
    else
      value
    end
  end

  def self.serialized_value(key)
    value_for_serialization key, self[key]
  end

  def self.value_for_serialization(key, value)
    if defaults[key][:type] == 'list' && value.is_a?(Array)
      value = value.collect { |entry| entry.join ',' } if value.all? { |entry| entry.is_a? Array }
      value.join("\n")
    else
      value.to_s
    end.gsub("\r\n", "\n")
  end

  def self.method_missing(name, *args)
    name_stripped = name.to_s.sub(/[\?=]$/, '')
    if keys.include?(name_stripped)
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
              [true, 1, '1', 'true', false, 0, '0', 'false'].include?(value)
            when 'decimal'
              begin
                BigDecimal(value)
              rescue StandardError
                false
              end
            when 'integer'
              begin
                Integer(value)
              rescue StandardError
                false
              end
            when 'list'
              value.is_a?(Array)
            when 'date'
              value.is_a?(Date)
            else
              true
            end
    errors.add(:value, I18n.t('activerecord.errors.messages.invalid')) unless valid
  end

  def serialize_value
    self.value = Configurable.value_for_serialization name, value
  end

  def invalidate_cache
    Rails.cache.delete(Configurable.cache_key(name))
  end
end
