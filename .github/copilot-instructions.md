<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# N+1 Workshop Rails Application

This is a Rails API application designed for teaching N+1 query problems and their solutions. The application demonstrates:

## Key Technologies

- **Rails 7.1** with PostgreSQL
- **GraphQL** with graphql-ruby gem
- **GraphQL-Batch** for DataLoader pattern
- **Bullet gem** for N+1 detection
- **Docker** for easy setup

## Workshop Focus Areas

### 1. Rails ActiveRecord N+1 Solutions

- `includes()` - Let Rails decide how to load
- `preload()` - Force separate queries
- `eager_load()` - Force LEFT OUTER JOIN
- Bullet gem integration for detection

### 2. GraphQL N+1 Solutions

- DataLoader pattern with GraphQL-Batch
- Batch loading functions
- Per-request caching

## Models & Relationships

- **User** has_many posts, comments
- **Post** belongs_to user, has_many comments, has_many tags (through post_tags)
- **Comment** belongs_to post, user
- **Tag** has_many posts (through post_tags)

## API Endpoints

- `/posts/n_plus_one` - Demonstrates N+1 problem
- `/posts/optimized` - Shows eager loading solution
- `/graphql` - GraphQL endpoint with both problematic and optimized queries

## Development Guidelines

- Always include examples that demonstrate the problem BEFORE showing the solution
- Use Bullet gem warnings to highlight N+1 issues
- Show SQL query logs to illustrate the difference
- Provide both Rails ORM and GraphQL examples for each concept
- Include timing/performance comparisons when possible

## Common Patterns

- Create "problematic" versions first for teaching
- Then create "optimized" versions that solve the N+1
- Use meaningful variable names that indicate the loading strategy
- Always include comments explaining why each approach works
