require 'spec_helper'

describe ConfigSetting do

  it "should save values to cache" do
    setting = ConfigSetting.create(key: "cache", value: "cache_it")
    assert_equal(ConfigSetting.from_cache(setting.key), setting.value)
  end

  it " should be invalid with empty key" do
    setting = ConfigSetting.new
    assert setting.invalid?(:key)
  end

  it "setting value sets value_class" do
    value = 123

    setting = ConfigSetting.new(:value => value)
    assert_equal(setting.value_class, value.class.to_s)
  end

  it "updating value updates value_class" do
    new_val = "abc"
    setting = ConfigSetting.new(:value => 10.0)
    setting.value = new_val
    assert_equal(setting.value_class, new_val.class.to_s)
  end

  it "keys must be unique" do
    key = "duplicate"
    setting1 = ConfigSetting.create(:key => key, :value => 123)
    setting2 = ConfigSetting.new(:key => key, :value => 456)
    assert !setting2.valid?
    assert setting2.invalid?(:key)
  end

  it "should return string value" do
    assert_value_properly_returned("abc")
  end

  it "should return integer value" do
    assert_value_properly_returned(123)
  end

  it "should return float value" do
    assert_value_properly_returned(123.4)
  end

  it "should return nil value" do
    assert_value_properly_returned(nil)
  end

  it "should return true value" do
    assert_value_properly_returned(true)
  end

  it "should return false value" do
    assert_value_properly_returned(false)
  end

  def assert_value_properly_returned(value)
    setting = ConfigSetting.create(:key => value.class.to_s, :value => value)
    unless setting.nil?
      assert_equal(setting.value, value)
      assert_equal(setting.value.class, value.class)
    end
  end
end
