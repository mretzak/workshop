# N+1 Workshop: Efficient Data Loading in Rails & GraphQL

A hands-on Rails application for learning about N+1 query problems and their solutions in both ActiveRecord and GraphQL contexts.

## 🎯 Workshop Objectives

Learn to identify, understand, and solve N+1 query problems using:

- **Rails ActiveRecord**: `includes`, `preload`, `eager_load`
- **GraphQL**: DataLoader pattern with `graphql-batch`
- **Detection Tools**: Bullet gem for automatic N+1 detection

## 🚀 Zero-Setup Start

### Prerequisites

- Docker and Docker Compose
- Git

### One-Command Setup

```bash
# Clone the repository
git clone <repository-url>
cd workshop

# Start everything with one command
./start-workshop.sh
```

That's it! The script will:

- 🐳 Build Docker containers
- 🗄️ Set up PostgreSQL database
- 🏃‍♂️ Run migrations automatically
- 🌱 Seed sample data
- 🌐 Start the Rails server

The application will be available at `http://localhost:3000`

### Alternative Docker Commands

```bash
# Manual Docker approach
docker compose up --build
# Database setup is automatic on first run!
```

### Zero-Setup Start (Recommended)

For the quickest start and a zero-setup experience for workshop participants:

1.  Ensure Docker Desktop is running.
2.  Clone this repository.
3.  Open your terminal, navigate to the project directory.
4.  Run the startup script:
    ```bash
    ./start-workshop.sh
    ```
5.  Wait for the script to build the Docker containers and set up the database.
6.  Once ready, you can access:
    - **Rails API (N+1 demo):** `http://localhost:3000/posts/n_plus_one`
    - **Rails API (Optimized demo):** `http://localhost:3000/posts/optimized`
    - **GraphQL Endpoint (for programmatic access):** `http://localhost:3000/graphql`
    - **GraphiQL UI (for interactive GraphQL queries):** `http://localhost:3000/graphiql`

### Accessing the Application

Once the Docker containers are up and the database is initialized (either manually or via the `start-workshop.sh` script):

- **Rails API (N+1 demo):** `http://localhost:3000/posts/n_plus_one`
- **Rails API (Optimized demo):** `http://localhost:3000/posts/optimized`
- **GraphQL Endpoint (for programmatic access):** `http://localhost:3000/graphql`
- **GraphiQL UI (for interactive GraphQL queries):** `http://localhost:3000/graphiql`
- **Bullet Gem Logs:** Check `log/bullet.log` or your browser's console for N+1 notifications.

## 🏗️ Manual Setup (without Docker)

### Prerequisites

- Ruby 3.3.1
- PostgreSQL
- Bundler

### Setup

```bash
# Install dependencies
bundle install

# Configure database (update config/database.yml if needed)
rails db:create db:migrate db:seed

# Start the server
rails server
```

## 📊 Sample Data

The seed file creates:

- 20 users with realistic names and emails
- 60-100 blog posts with random content
- 200-400 comments on posts
- 10 tags with many-to-many relationships

## 🔍 Workshop Demonstrations

### Rails ActiveRecord N+1 Examples

#### The Problem

```bash
# This endpoint demonstrates N+1 queries
curl http://localhost:3000/posts/n_plus_one
```

Check your Rails logs - you'll see:

```sql
SELECT "posts".* FROM "posts"                    -- 1 query
SELECT "users".* FROM "users" WHERE "users"."id" = 1  -- N queries
SELECT "users".* FROM "users" WHERE "users"."id" = 2  -- (one per post)
-- ... many more queries
```

#### The Solutions

```bash
# Different eager loading strategies
curl http://localhost:3000/posts/includes    # Let Rails decide
curl http://localhost:3000/posts/preload     # Separate queries
curl http://localhost:3000/posts/eager_load  # LEFT OUTER JOIN
curl http://localhost:3000/posts/optimized   # Optimized version
```

### GraphQL N+1 Examples

Access GraphQL playground at `http://localhost:3000/graphql`

#### The Problem Query

```graphql
query {
  posts {
    title
    user {
      name
    }
    comments {
      content
    }
    commentsCount
  }
}
```

#### The Optimized Query

```graphql
query {
  optimizedPosts {
    title
    user {
      name
    }
    comments {
      content
    }
    commentsCount
  }
}
```

## 🛠️ Workshop Challenges

See [WORKSHOP_CHALLENGES.md](WORKSHOP_CHALLENGES.md) for hands-on exercises.

### Challenge 1: Fix Rails N+1

Identify and fix N+1 queries in a Rails controller using appropriate eager loading.

### Challenge 2: Implement GraphQL DataLoader

Create a DataLoader to batch-load user data in GraphQL resolvers.

## 📁 Project Structure

```
app/
├── controllers/
│   ├── posts_controller.rb      # N+1 examples & solutions
│   └── users_controller.rb      # More N+1 examples
├── graphql/
│   ├── loaders/                 # DataLoader implementations
│   └── types/                   # GraphQL types (problem & optimized)
└── models/                      # User, Post, Comment, Tag models

config/
└── environments/
    └── development.rb           # Bullet gem configuration
```

## 🔧 Key Technologies

- **Rails 7.1** - Web framework
- **PostgreSQL** - Database
- **GraphQL-Ruby** - GraphQL implementation
- **GraphQL-Batch** - DataLoader pattern
- **Bullet** - N+1 query detection
- **Faker** - Sample data generation

## 📈 Performance Monitoring

### Bullet Gem Integration

The Bullet gem is configured to detect N+1 queries automatically:

- Console alerts
- Rails log warnings
- Browser notifications (in development)

### Manual Monitoring

Watch your Rails logs while making requests to see:

- SQL query counts
- Query execution times
- N+1 detection warnings

## 🎓 Learning Resources

### Rails Eager Loading

- `includes(:association)` - Smart loading (separate queries OR joins)
- `preload(:association)` - Always use separate queries
- `eager_load(:association)` - Always use LEFT OUTER JOIN

### GraphQL DataLoader Pattern

- Batch loading to reduce database queries
- Per-request caching
- Lazy evaluation for optimal performance

## 🤝 Workshop Format

1. **Introduction (10 min)**: N+1 problem explanation
2. **Rails Examples (30 min)**: Live coding and challenges
3. **GraphQL Examples (35 min)**: DataLoader implementation
4. **Discussion (15 min)**: Best practices and Q&A

## 🐛 Troubleshooting

### Database Issues

```bash
# Reset database
docker compose exec web rails db:drop db:create db:migrate db:seed

# Or without Docker
rails db:reset
```

### Docker Issues

```bash
# Rebuild containers
docker compose down
docker compose up --build
```

## 📝 License

This project is designed for educational purposes as part of the N+1 workshop.
