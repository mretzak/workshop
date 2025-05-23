module Types
  class OptimizedCommentType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :post, Types::OptimizedPostType, null: false
    field :user, Types::OptimizedUserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Using DataLoaders to prevent N+1 queries
    def post
      Loaders::PostLoader.load(object.post_id)
    end

    def user
      Loaders::UserLoader.load(object.user_id)
    end
  end
end
