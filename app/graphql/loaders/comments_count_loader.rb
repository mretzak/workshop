class Loaders::CommentsCountLoader < GraphQL::Batch::Loader
  def perform(post_ids)
    counts = Comment.where(post_id: post_ids).group(:post_id).count
    post_ids.each { |id| fulfill(id, counts[id] || 0) }
  end
end
