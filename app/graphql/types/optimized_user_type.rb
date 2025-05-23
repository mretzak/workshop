module Types
  class OptimizedUserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :posts, [Types::OptimizedPostType], null: false
    field :comments, [Types::OptimizedCommentType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Using DataLoader to prevent N+1 queries
    def posts
      Loaders::PostsByUserLoader.load(object.id)
    end

    def comments
      object.comments # For demo - could also be optimized with a loader
    end
  end
end
