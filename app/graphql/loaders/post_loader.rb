class Loaders::PostLoader < GraphQL::Batch::Loader
  def perform(post_ids)
    posts = Post.where(id: post_ids).index_by(&:id)
    post_ids.each { |id| fulfill(id, posts[id]) }
  end
end
