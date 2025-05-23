class Loaders::TagsByPostLoader < GraphQL::Batch::Loader
  def perform(post_ids)
    post_tags = PostTag.includes(:tag).where(post_id: post_ids)
    tags_by_post = post_tags.group_by(&:post_id).transform_values do |post_tags|
      post_tags.map(&:tag)
    end

    post_ids.each { |id| fulfill(id, tags_by_post[id] || []) }
  end
end
