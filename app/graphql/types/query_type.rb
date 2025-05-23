# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # These queries will demonstrate N+1 problems

    field :users, [Types::UserType], null: false, description: "All users (will cause N+1)"
    field :posts, [Types::PostType], null: false, description: "All posts (will cause N+1)"
    field :comments, [Types::CommentType], null: false, description: "All comments (will cause N+1)"
    field :published_posts, [Types::PostType], null: false, description: "Published posts only"

    # Optimized queries using DataLoaders and eager loading
    field :optimized_users, [Types::OptimizedUserType], null: false, description: "Users with optimized loading"
    field :optimized_posts, [Types::OptimizedPostType], null: false, description: "Posts with optimized loading"
    field :optimized_published_posts, [Types::OptimizedPostType], null: false, description: "Published posts with optimized loading"

    # Rails eager loading examples
    field :eager_loaded_posts, [Types::PostType], null: false, description: "Posts with Rails eager loading"

    # N+1 demonstration queries
    def users
      User.all
    end

    def posts
      Post.all
    end

    def comments
      Comment.all
    end

    def published_posts
      Post.published
    end

    # Optimized queries
    def optimized_users
      User.all
    end

    def optimized_posts
      Post.all
    end

    def optimized_published_posts
      Post.published
    end

    # Rails eager loading - solves N+1 at the ORM level
    def eager_loaded_posts
      Post.includes(:user, :comments, :tags)
    end
  end
end
