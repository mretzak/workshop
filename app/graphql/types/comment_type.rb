module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :post, Types::PostType, null: false
    field :user, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # This resolver will cause N+1 queries - used for demonstration
    def post
      object.post
    end

    # This resolver will cause N+1 queries - used for demonstration
    def user
      object.user
    end
  end
end
