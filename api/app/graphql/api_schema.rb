class ApiSchema < GraphQL::Schema
  query(Types::QueryType)
end
