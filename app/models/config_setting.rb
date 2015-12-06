class ConfigSetting < ActiveRecord::Base
  validates_presence_of :key
  validates_uniqueness_of :key
  validate :value_class_attribute_matches_value
  after_save :save_to_cash

  attr_accessor :return_val

  class << self
    def from_cache(cache_key)
      Rails.cache.fetch cache_key
    end
  end

  def value=(obj)
    self.value_class = obj.class.to_s
    self.value_str = obj
    { value_class: value_class, value_str: value_str }
  end

  def value
    if @return_val.nil?
      @return_val = case value_class
        when "String"
          value_str
        when "Fixnum"
          value_str.to_i
        when "Float"
          value_str.to_f
        when "NilClass"
          nil
        when "TrueClass"
          true
        when "FalseClass"
          false
      end
    end
    @return_val
  end

  private

  def value_class_attribute_matches_value
    unless value.class.to_s == value_class
      errors.add(:base, "the class of the Value must match the value_class")
    end
  end

  def save_to_cash
    Rails.cache.write key, value_str
  end
end

