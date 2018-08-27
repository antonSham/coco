module Types
  class QueryType < Types::BaseObject
    field :countries, [Types::CountryObject], null: false
    def countries
      Country.get_all_for_graphql
    end
  end
end
