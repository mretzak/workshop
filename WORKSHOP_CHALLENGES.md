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

### The Scenario

Imagine a GraphQL query for posts where you _always_ want to show the author's name and the post's tags because they are fundamental to the display. However, comments for a post might only be shown if the user clicks a "View Comments" button, or perhaps they are paginated and loaded on demand. In such cases, eager-loading everything might be inefficient if some data isn't always needed.

### Your Task

1.  **Identify Eager Load Candidates**: For a GraphQL query that fetches posts, their authors, tags, and comments, decide which associations are suitable for Rails eager loading (always needed) and which are better handled by DataLoaders (conditionally or less frequently needed).
2.  **Implement Mixed Loading**:
    - Modify an existing GraphQL query (e.g., `optimizedPosts` or create a new one like `mixedLoadedPosts`) to use Rails `includes` (or `preload`/`eager_load`) for the `user` and `tags` associations directly within the primary resolver that fetches the posts.
    - Ensure that the `comments` association (or another association of your choice if comments are also eager-loaded) continues to be loaded via its DataLoader.
3.  **Verify Efficiency**: Compare the SQL logs before and after your changes. You should see that the queries for users and tags are part of the initial post loading (or batched efficiently by Rails), while comments are still loaded in batches by their DataLoader when requested.

### Hints

- In your GraphQL resolver for posts (e.g., in `app/graphql/types/query_type.rb`), when fetching `Post.all`, you can chain `.includes(:user, :tags)`.
- Ensure your `PostType` still defines fields for `user`, `tags`, and `comments`, and that the resolvers for these fields (especially `comments`) correctly use DataLoaders if they are not part of the initial eager load.
- Think about the data access patterns: what's displayed immediately vs. what's loaded on interaction?

### Test Your Solution

1.  Construct a GraphQL query that requests posts along with their user (name), tags (name), and comments (content).
2.  Run this query against your new/modified GraphQL field.
3.  Examine the Rails console logs:
    - You should see fewer individual N+1 queries for `users` and `tags` associated with each post. Ideally, they are fetched in one or two additional queries by Rails' eager loading mechanism when the posts themselves are loaded.
    - You should still see the `CommentsByPostLoader` (or similar) being invoked and batching queries if you request comments.
4.  Compare this to a version of the query that relies purely on DataLoaders for all associations, or one that has no N+1 protection, to see the difference in query patterns.

---
