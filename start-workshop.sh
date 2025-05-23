#!/bin/bash

echo "🎯 N+1 Workshop - Zero Setup Start"
echo "=================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "🚀 Starting workshop application..."
echo "This will:"
echo "  📦 Build the Docker containers"
echo "  🗄️  Set up PostgreSQL database"
echo "  🌱 Run migrations and seed data"
echo "  🌐 Start the Rails server"
echo ""

# Start the application
docker compose up --build

echo ""
echo "⏳ Waiting for services to be fully up and database to be ready..."
echo "   This might take a minute or two on the first run as images are built and the database is seeded."
echo ""

# Function to check if the app is ready
check_app_ready() {
    # Check for a specific log message from docker-entrypoint that indicates readiness
    docker-compose logs web | grep -q "🎯 Workshop endpoints ready:"
}

# Wait for the app to be ready
while ! check_app_ready; do
    echo "   Still waiting for workshop application to initialize..."
    sleep 5
done

echo ""
echo "🎉🚀 N+1 Workshop application is ready! 🚀🎉"
echo ""
echo "You can access the following endpoints:"
echo "  👉 Rails API (N+1 example):    http://localhost:3000/posts/n_plus_one"
echo "  👉 Rails API (Optimized):      http://localhost:3000/posts/optimized"
echo "  👉 GraphQL Endpoint:           http://localhost:3000/graphql"
echo "  👉 GraphiQL UI (Query Editor): http://localhost:3000/graphiql"
echo ""
echo "Next steps:"
echo "  1. Open WORKSHOP_CHALLENGES.md to begin."
echo "  2. Explore the GraphQL queries in GRAPHQL_QUERIES.md."
echo "  3. Review the facilitator guide in FACILITATOR_GUIDE.md."
echo ""
echo "💡 To stop: Press Ctrl+C, then run 'docker compose down'"
