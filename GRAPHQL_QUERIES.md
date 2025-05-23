# GraphQL Workshop Queries

## Basic Queries (These will cause N+1!)

### Get all posts with user information

```graphql
query PostsWithUsers {
  posts {
    id
    title
    user {
      name
      email
    }
  }
}
```

### Get posts with comments and user info

```graphql
query PostsWithCommentsAndUsers {
  posts {
    id
    title
    user {
      name
    }
    comments {
      content
      user {
        name
      }
    }
    commentsCount
  }
}
```

### Get posts with all associations (Heavy N+1!)

```graphql
query PostsWithAllAssociations {
  posts {
    id
    title
    content
    user {
      name
      email
    }
    comments {
      id
      content
      user {
        name
      }
    }
    tags {
      id
      name
    }
    commentsCount
  }
}
```

## Optimized Queries (Using DataLoaders)

### Optimized posts query

```graphql
query OptimizedPosts {
  optimizedPosts {
    id
    title
    user {
      name
    }
    comments {
      content
      user {
        name
      }
    }
    commentsCount
  }
}
```

### Optimized users with posts

```graphql
query OptimizedUsers {
  optimizedUsers {
    id
    name
    posts {
      title
      commentsCount
    }
  }
}
```

### Compare both approaches

```graphql
query CompareApproaches {
  # This will cause N+1
  regularPosts: posts {
    title
    user {
      name
    }
  }

  # This uses DataLoaders
  optimizedPosts {
    title
    user {
      name
    }
  }
}
```

## Challenge Queries

Use these to test your solutions:

### Challenge 1: Fix the author loading

```graphql
query AuthorChallenge {
  posts {
    title
    user {
      # Fix the N+1 here!
      name
      email
    }
  }
}
```

### Challenge 2: Fix comment counts

```graphql
query CommentCountChallenge {
  posts {
    title
    commentsCount # Fix the N+1 here!
  }
}
```

### Challenge 3: Fix nested associations

```graphql
query NestedChallenge {
  posts {
    title
    comments {
      content
      user {
        # Fix the N+1 here!
        name
      }
    }
  }
}
```

## Monitoring Tips

1. **Watch your Rails logs** - Count the SELECT statements
2. **Use GraphQL query complexity** - Limit expensive queries
3. **Profile with tools** - Use Ruby profilers for detailed analysis
4. **Bullet gem warnings** - Check console for N+1 alerts

## Expected Results

### Before optimization:

- 1 query for posts
- N queries for users (one per post)
- N queries for comments (one per post)
- N queries for tags (one per post)

### After optimization:

- 1 query for posts
- 1 batched query for all users
- 1 batched query for all comments
- 1 batched query for all tags
