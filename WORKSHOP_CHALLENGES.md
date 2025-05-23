# N+1 Workshop Challenges

## Challenge 1: Rails ActiveRecord N+1 Problem

### The Problem

Look at this controller action that's causing N+1 queries:

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all

    # This view will cause N+1 queries
    render json: @posts.map do |post|
      {
        title: post.title,
        author: post.user.name,        # N+1 query here!
        comments_count: post.comments.size,  # N+1 query here!
        tags: post.tags.map(&:name)    # N+1 query here!
      }
    end
  end
end
```

### Your Task

1. **Identify the N+1**: What line(s) cause N+1 queries?
2. **Fix it**: Rewrite the controller to eliminate N+1 using Rails eager loading
3. **Choose the right method**: Decide between `includes`, `preload`, or `eager_load`

### Hints

- `includes`: Let Rails decide (separate queries or JOIN)
- `preload`: Force separate queries
- `eager_load`: Force LEFT OUTER JOIN

### Test Your Solution

```bash
# Run the problematic version
curl http://localhost:3000/posts/n_plus_one

# Run your optimized version
curl http://localhost:3000/posts/optimized
```

Check the Rails logs to see the difference in SQL queries!

---

## Challenge 2: GraphQL N+1 Problem

### The Problem

This GraphQL query causes N+1:

```graphql
query {
  posts {
    title
    user {
      # N+1 query for each post!
      name
    }
    comments {
      # N+1 query for each post!
      content
    }
    tags {
      # N+1 query for each post!
      name
    }
  }
}
```

### Your Task

1. **Create a DataLoader**: Write a batch loading function for post authors
2. **Update the resolver**: Modify the PostType to use your DataLoader
3. **Test it**: Compare before/after SQL query counts

### DataLoader Template

```ruby
class Loaders::AuthorLoader < GraphQL::Batch::Loader
  def perform(user_ids)
    # Your batch loading logic here
    # Hint: Load all users at once, then fulfill each ID
  end
end
```

### Test Your Solution

```graphql
# Try both queries and watch the logs:

# Original (N+1):
query {
  posts {
    title
    user {
      name
    }
  }
}

# Optimized:
query {
  optimizedPosts {
    title
    user {
      name
    }
  }
}
```

---

## Bonus Challenge: Mixed Approach

Can you create a solution that uses both Rails eager loading AND GraphQL DataLoaders for maximum efficiency?
