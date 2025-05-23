# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'

# Clear existing data
Comment.destroy_all
PostTag.destroy_all
Post.destroy_all
Tag.destroy_all
User.destroy_all

puts "Creating sample data for N+1 workshop..."

# Create users
users = []
20.times do
  users << User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )
end

puts "Created #{users.length} users"

# Create tags
tags = []
10.times do
  tags << Tag.find_or_create_by!(name: Faker::Book.genre) # Changed to find_or_create_by!
end

puts "Created #{tags.length} tags"

# Create posts
posts = []
users.each do |user|
  rand(1..5).times do
    post = Post.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraphs(number: rand(3..8)).join("\n\n"),
      user: user,
      published_at: [nil, Faker::Time.between(from: 1.month.ago, to: Time.now)].sample
    )

    # Add random tags to posts
    post.tags = tags.sample(rand(1..3))
    posts << post
  end
end

puts "Created #{posts.length} posts"

# Create comments
comment_count = 0
posts.each do |post|
  rand(0..8).times do
    Comment.create!(
      content: Faker::Lorem.sentences(number: rand(1..3)).join(" "),
      post: post,
      user: users.sample
    )
    comment_count += 1
  end
end

puts "Created #{comment_count} comments"
puts "Sample data creation complete!"
puts ""
puts "Workshop data summary:"
puts "- #{User.count} users"
puts "- #{Post.count} posts"
puts "- #{Comment.count} comments"
puts "- #{Tag.count} tags"
puts "- #{PostTag.count} post-tag associations"
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
