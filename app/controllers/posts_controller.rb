class PostsController < ApplicationController
  # This action will cause N+1 queries - for demonstration
  def index_with_n_plus_one
    @posts = Post.all # This will cause N+1 when accessing post.user, post.comments, etc.
    render json: posts_json(@posts)
  end

  # This action uses eager loading to prevent N+1
  def index_optimized
    @posts = Post.includes(:user, :comments, :tags)
    render json: posts_json(@posts)
  end

  # Different eager loading strategies
  def index_with_includes
    # Let Rails decide how to load (might use separate queries or joins)
    @posts = Post.includes(:user, :comments, :tags)
    render json: posts_json(@posts)
  end

  def index_with_preload
    # Force separate queries
    @posts = Post.preload(:user, :comments, :tags)
    render json: posts_json(@posts)
  end

  def index_with_eager_load
    # Force LEFT OUTER JOIN
    @posts = Post.eager_load(:user, :comments, :tags)
    render json: posts_json(@posts)
  end

  private

  def posts_json(posts)
    posts.map do |post|
      {
        id: post.id,
        title: post.title,
        user_name: post.user.name, # This line causes N+1 without eager loading
        comments_count: post.comments.size, # This line causes N+1 without eager loading
        tag_names: post.tags.map(&:name) # This line causes N+1 without eager loading
      }
    end
  end
end
