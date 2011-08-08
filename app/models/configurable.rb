class Configurable < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  def self.defaults
    HashWithIndifferentAccess.new(
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
    value = find_by_name(key).try(:value) || self.defaults[key][:default]
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

end
