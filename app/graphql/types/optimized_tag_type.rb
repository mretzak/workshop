module Types
  class OptimizedTagType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :posts, [Types::OptimizedPostType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def posts
      object.posts # Could be optimized with a loader if needed
    end
  end
end
