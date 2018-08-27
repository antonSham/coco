module Types
  class CountryObject < BaseObject
    field :code, String, null: true do
      description "Unique 3-letter country code"
    end
    field :name, String, null: true do
      description "Country name"
    end
    field :population_density, Float, null: true do
      description "Population density (people / squere km)"
    end
    field :currency, String, null: true do
      description "Currency code (usually 3-letter)"
    end
    field :conversion_rate, Float, null: true do
      description "Conversation rate with EUR"
    end
  end
end
