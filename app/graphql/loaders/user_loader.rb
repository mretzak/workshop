class Loaders::UserLoader < GraphQL::Batch::Loader
  def perform(user_ids)
    users = User.where(id: user_ids).index_by(&:id)
    user_ids.each { |id| fulfill(id, users[id]) }
  end
end
