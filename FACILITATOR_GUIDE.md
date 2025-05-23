# Workshop Facilitator Guide

## Pre-Workshop Setup (5 minutes)

1. **Start the application:**

   ```bash
   docker compose up --build
   # OR
   rails server
   ```

2. **Verify endpoints work:**

   - http://localhost:3000/posts/n_plus_one
   - http://localhost:3000/graphql

3. **Open monitoring tools:**
   - Rails console: `rails console`
   - Logs: `tail -f log/development.log`

## Workshop Timeline

### 1. Introduction (10 minutes)

**Key Points:**

- What is N+1? (1 query becomes N+1 queries)
- Why is it bad? (Performance, database load)
- How to spot it? (Bullet gem, logs, query counts)

**Demo:**

```bash
# Show the problem
curl http://localhost:3000/posts/n_plus_one

# Count the queries in logs
# Should see: 1 query for posts + N queries for users
```

### 2. Rails ActiveRecord Solutions (30 minutes)

#### 2.1 Demonstrate the Problem (5 minutes)

```ruby
# Show this code in posts_controller.rb
@posts = Post.all
@posts.each { |post| puts post.user.name }  # N+1!
```

#### 2.2 Explain Solutions (5 minutes)

- `includes` - Smart loading
- `preload` - Separate queries
- `eager_load` - JOIN queries

#### 2.3 Mini-Challenge (15 minutes)

Give participants this broken code:

```ruby
def index
  @posts = Post.all
  render json: @posts.map do |post|
    {
      title: post.title,
      author: post.user.name,
      comments_count: post.comments.size
    }
  end
end
```

**Task:** Fix the N+1 using appropriate eager loading.

#### 2.4 Review Solutions (5 minutes)

```ruby
# Solution:
@posts = Post.includes(:user, :comments)
```

### 3. GraphQL DataLoader Solutions (35 minutes)

#### 3.1 Demonstrate GraphQL N+1 (5 minutes)

```graphql
query {
  posts {
    title
    user {
      name
    } # N+1 here!
  }
}
```

#### 3.2 Explain DataLoader Pattern (10 minutes)

- Batching mechanism
- Per-request cache
- Lazy evaluation

**Show the pattern:**

```ruby
class Loaders::UserLoader < GraphQL::Batch::Loader
  def perform(user_ids)
    users = User.where(id: user_ids).index_by(&:id)
    user_ids.each { |id| fulfill(id, users[id]) }
  end
end
```

#### 3.3 Mini-Challenge (15 minutes)

**Task:** Implement a DataLoader for post comments.

Template:

```ruby
class Loaders::CommentsByPostLoader < GraphQL::Batch::Loader
  def perform(post_ids)
    # TODO: Load comments for all post_ids at once
    # TODO: Group by post_id
    # TODO: Fulfill each post_id with its comments
  end
end
```

#### 3.4 Review Solutions (5 minutes)

Show the complete implementation and how to use it in resolvers.

### 4. Synthesis & Best Practices (15 minutes)

#### 4.1 Compare Approaches (5 minutes)

| Rails ORM      | GraphQL     |
| -------------- | ----------- |
| Eager loading  | DataLoaders |
| Query-level    | Field-level |
| All-or-nothing | Selective   |

#### 4.2 Detection & Prevention (5 minutes)

- Bullet gem setup
- Code review checklists
- Performance monitoring

#### 4.3 Q&A (5 minutes)

## Workshop Materials Checklist

- [ ] Application running
- [ ] Sample data seeded
- [ ] GraphQL playground accessible
- [ ] Bullet gem showing N+1 warnings
- [ ] Challenge files ready
- [ ] Logs visible

## Common Issues & Solutions

**Database connection errors:**

```bash
docker compose down
docker compose up --build
```

**No sample data:**

```bash
rails db:seed
```

**Bullet not showing warnings:**
Check `config/environments/development.rb` configuration.

## Extension Activities

For advanced participants:

1. Implement counter caches
2. Add query complexity analysis
3. Create custom DataLoader with caching
4. Benchmark different approaches

## Resources for Participants

- [Rails Guides: Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
- [GraphQL-Batch Documentation](https://github.com/Shopify/graphql-batch)
- [Bullet Gem](https://github.com/flyerhzm/bullet)
