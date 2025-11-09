#!/bin/bash

set -e

echo "🚀 Setting up Distributed Notification System (Python/FastAPI)..."

# Check prerequisites
command -v python3 >/dev/null 2>&1 || { echo "❌ Python 3 is required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required"; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "❌ Docker Compose is required"; exit 1; }

echo "✅ Prerequisites check passed"

# Copy environment file
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please update .env with your actual values"
else
    echo "✅ .env file exists"
fi

# Create virtual environment for local development
if [ ! -d "venv" ]; then
    echo "🐍 Creating Python virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment exists"
    source venv/bin/activate
fi

# Install shared dependencies
echo "📦 Installing shared dependencies..."
if [ -f "shared/requirements-base.txt" ]; then
    pip install -r shared/requirements-base.txt
fi

# Start Docker services
echo "🐳 Starting Docker services..."
docker-compose up --build -d

# Wait for services
echo "⏳ Waiting for services to be healthy..."
sleep 15

# Check service health
echo "🏥 Checking service health..."
services=("api-gateway" "user-service" "email-service" "push-service" "template-service")
for service in "${services[@]}"; do
    if docker-compose ps | grep -q "$service.*Up"; then
        echo "✅ $service is running"
    else
        echo "❌ $service failed to start"
    fi
done

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📍 Services available at:"
echo "   - API Gateway: http://localhost:8000"
echo "   - API Gateway Docs: http://localhost:8000/docs"
echo "   - User Service: http://localhost:8001/docs"
echo "   - Email Service: http://localhost:8002/docs"
echo "   - Push Service: http://localhost:8003/docs"
echo "   - Template Service: http://localhost:8004/docs"
echo "   - RabbitMQ Management: http://localhost:15672 (guest/guest)"
echo ""
echo "📚 Useful commands:"
echo "   - View logs: docker-compose logs -f [service-name]"
echo "   - Stop services: docker-compose down"
echo "   - Restart service: docker-compose restart [service-name]"
echo "   - Run tests: pytest"
echo "   - Activate venv: source venv/bin/activate"