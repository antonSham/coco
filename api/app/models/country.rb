class Country < ApplicationRecord

  def self.get_by_code code
    Country.where(:code => code).first
  end

  def self.update_info current_country_info
    Country.transaction do
      country = Country.get_by_code(current_country_info[:code])
      unless (country)
          Country.create(current_country_info)
        else
          unless (country[:currency] == current_country_info[:currency])
            country.conversion_rate_usd = nil
          end
          country.update(current_country_info)
          country.save!
      end
    end
  end

  def self.get_currencies
    Country.where.not(:currency => nil).select(:currency).map(&:currency).uniq
  end
end
