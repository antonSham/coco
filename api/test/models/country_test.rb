require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  options = {
    :name => "Third country",
    :code => "TCC",
    :population_density => 12.32,
    :currency => "TCC"
  }

  test "Adds new country" do
    Country.update_info(options)

    assert_equal 1, Country.where(:code => options[:code]).length
  end

  test "Does not duplicate" do
    Country.update_info(options)
    Country.update_info(options)

    assert_equal 1, Country.where(:code => options[:code]).length
  end

  test "Does not erase conversion_rate after ordinary update" do
    conversion_rate = 34
    Country.update_info(options)
    Country.get_by_code(options[:code]).update(:conversion_rate_usd => conversion_rate)

    Country.update_info(options)
    assert_equal conversion_rate, Country.get_by_code(options[:code])[:conversion_rate_usd]
  end

  test "Erases conversion_rate after currency name update" do
    Country.update_info(options)
    Country.get_by_code(options[:code]).update(:conversion_rate_usd => 34)

    Country.update_info(options.merge(:currency => "NNN"))
    assert_nil Country.get_by_code(options[:code])[:conversion_rate_usd]
  end

  test "Gets courancy list" do
    Country.update_info(options)
    assert_equal ["FCC", "SCC", "TCC"].sort, Country.get_currencies.sort
  end

  test "Does not duplicate currencies" do
    Country.update_info(options)
    Country.update_info(options.merge(:code => "NN"))
    assert_equal ["FCC", "SCC", "TCC"].sort, Country.get_currencies.sort
  end

  test "Does not get nil currencies" do
    Country.update_info(options.merge(:currency => nil))
    assert_equal ["FCC", "SCC"].sort, Country.get_currencies.sort
  end
end
