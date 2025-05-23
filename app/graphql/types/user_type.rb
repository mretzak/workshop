module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :posts, [Types::PostType], null: false
    field :comments, [Types::CommentType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # This resolver will cause N+1 queries - used for demonstration
    def posts
      object.posts
    end

    # This resolver will cause N+1 queries - used for demonstration
    def comments
      object.comments
    end
  end
end
