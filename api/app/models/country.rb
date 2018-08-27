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
            country.conversion_rate_eur = nil
          end
          country.update(current_country_info)
          country.save!
      end
    end
  end

  def self.get_currencies
    Country.where.not(:currency => nil).select(:currency).map(&:currency).uniq
  end

  def self.update_conversation_rate currency_code, value
    Country.where(:currency => currency_code).update(:conversion_rate_eur => value)
  end

  def self.get_all_for_graphql
    Country.where.not(:conversion_rate_eur => nil).select(
      :code,
      :name,
      :population_density,
      :currency,
      'conversion_rate_eur AS conversion_rate'
    )
  end
end
