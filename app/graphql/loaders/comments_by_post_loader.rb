class Loaders::CommentsByPostLoader < GraphQL::Batch::Loader
  def perform(post_ids)
    comments_by_post = Comment.where(post_id: post_ids).group_by(&:post_id)
    post_ids.each { |id| fulfill(id, comments_by_post[id] || []) }
  end
end
