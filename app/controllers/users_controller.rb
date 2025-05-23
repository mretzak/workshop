class UsersController < ApplicationController
  # N+1 demonstration
  def index_with_n_plus_one
    @users = User.all
    render json: users_json(@users)
  end

  # Optimized version
  def index_optimized
    @users = User.includes(:posts, :comments)
    render json: users_json(@users)
  end

  private

  def users_json(users)
    users.map do |user|
      {
        id: user.id,
        name: user.name,
        email: user.email,
        posts_count: user.posts.size, # N+1 without eager loading
        comments_count: user.comments.size # N+1 without eager loading
      }
    end
  end
end
