module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :content, String, null: false
    field :published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :user, Types::UserType, null: false
    field :comments, [Types::CommentType], null: false
    field :tags, [Types::TagType], null: false
    field :comments_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # This resolver will cause N+1 queries - used for demonstration
    def user
      object.user
    end

    # This resolver will cause N+1 queries - used for demonstration
    def comments
      object.comments
    end

    # This resolver will cause N+1 queries - used for demonstration
    def tags
      object.tags
    end

    # This resolver will cause N+1 queries - used for demonstration
    def comments_count
      object.comments.count
    end
  end
end
