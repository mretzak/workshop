module Types
  class TagType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :posts, [Types::PostType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # This resolver will cause N+1 queries - used for demonstration
    def posts
      object.posts
    end
  end
end
