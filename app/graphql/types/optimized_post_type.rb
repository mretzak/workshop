module Types
  class OptimizedPostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :content, String, null: false
    field :published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :user, Types::OptimizedUserType, null: false
    field :comments, [Types::OptimizedCommentType], null: false
    field :tags, [Types::OptimizedTagType], null: false
    field :comments_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Using DataLoaders to prevent N+1 queries
    def user
      Loaders::UserLoader.load(object.user_id)
    end

    def comments
      Loaders::CommentsByPostLoader.load(object.id)
    end

    def tags
      Loaders::TagsByPostLoader.load(object.id)
    end

    def comments_count
      Loaders::CommentsCountLoader.load(object.id)
    end
  end
end
