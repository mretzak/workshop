class Loaders::PostsByUserLoader < GraphQL::Batch::Loader
  def perform(user_ids)
    posts_by_user = Post.where(user_id: user_ids).group_by(&:user_id)
    user_ids.each { |id| fulfill(id, posts_by_user[id] || []) }
  end
end
