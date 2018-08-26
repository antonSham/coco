require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test "Added new country" do
    Country.update_info({
      :name => "Fake country",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FCV"
    })

    assert_equal 1, Country.where(:code => "FCO").length
  end

  test "Do not duplicate" do
    Country.update_info({
      :name => "Fake country",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FCV"
    })

    Country.update_info({
      :name => "Fake country",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FCV"
    })

    assert_equal 1, Country.where(:code => "FCO").length
  end

  test "Erase conversion_rate after currency name update" do
    Country.update_info({
      :name => "Fake country",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FCV"
    })

    Country.get_by_code("FCO").update(:conversion_rate_usd => 34)

    Country.update_info({
      :name => "Fake country",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FDV"
    })

    assert_nil Country.get_by_code("FCO")[:conversion_rate_usd]
  end

  test "Do not erase conversion_rate after ordinary update" do
    Country.update_info({
      :name => "Fake country",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FCV"
    })

    Country.get_by_code("FCO").update(:conversion_rate_usd => 34)

    Country.update_info({
      :name => "Fake country name",
      :code => "FCO",
      :population_density => 12.32,
      :currency => "FCV"
    })

    assert_equal 34, Country.get_by_code("FCO")[:conversion_rate_usd]
  end
end
