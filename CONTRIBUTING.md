## 🔍 Troubleshooting

### Services Won't Start

```bash
# Check Docker is running
docker ps

# Check logs for errors
docker-compose logs

# Restart Docker daemon
sudo systemctl restart docker

# Remove and recreate containers
docker-compose down -v
docker-compose up --build -d
```

### Database Connection Issues

```bash
# Check if PostgreSQL is running
docker-compose ps postgres-user

# Check database logs
docker-compose logs postgres-user

# Verify environment variables
cat .env | grep DB_

# Test database connection
docker-compose exec postgres-user psql -U postgres -d user_service_db
```

### RabbitMQ Issues

```bash
# Check if RabbitMQ is running
docker-compose ps rabbitmq

# Access management UI
# http://localhost:15672 (guest/guest)

# Check queue status
docker-compose exec rabbitmq rabbitmqctl list_queues

# Restart RabbitMQ
docker-compose restart rabbitmq
```

### Python Import Errors

```bash
# Activate virtual environment
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt --force-reinstall

# Set PYTHONPATH
export PYTHONPATH=/app/src
```

### Port Already in Use

```bash
# Find process using port
lsof -i :8000

# Kill process
kill -9 <PID>

# Or change port in .env file
```

---

## 📝 Code Quality

### Formatting

```bash
# Format code with Black
black .

# Check without applying
black --check .

# Format specific file
black services/api-gateway/src/main.py
```

### Import Sorting

```bash
# Sort imports with isort
isort .

# Check without applying
isort --check-only .
```

### Linting

```bash
# Lint with Flake8
flake8 .

# Show statistics
flake8 --statistics .

# Check specific directory
flake8 services/api-gateway/src/
```

### Type Checking

```bash
# Run MyPy type checker
mypy src/

# Check specific service
mypy services/user-service/src/
```

### Run All Checks

```bash
# Run all quality checks
black . && isort . && flake8 . && mypy src/ && pytest
```

---

## 🚀 Deployment

### CI/CD Pipeline

The project includes GitHub Actions workflow for:

- Automated testing
- Code quality checks
- Docker image building
- Deployment to server

### Request Deployment Server

```bash
# In your project channel
/request-server
```

### Manual Deployment

```bash
# Build production images
docker-compose -f docker-compose.yml build

# Push to registry
docker-compose push

# Deploy on server
docker-compose -f docker-compose.yml up -d
```

---

## 📊 Monitoring

### Health Checks

```bash
# Check all services
curl http://localhost:8000/health
curl http://localhost:8001/health
curl http://localhost:8002/health
curl http://localhost:8003/health
curl http://localhost:8004/health
```

### Logs

```bash
# View all logs
docker-compose logs -f

# Filter by service
docker-compose logs -f api-gateway

# Last 100 lines
docker-compose logs --tail=100

# Follow new logs only
docker-compose logs -f --since 5m
```

### RabbitMQ Monitoring

Access management UI at http://localhost:15672:

- Queue lengths
- Message rates
- Consumer status
- Connection details

---

## 📖 Additional Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Documentation](https://docs.docker.com/)
- [RabbitMQ Tutorial](https://www.rabbitmq.com/getstarted.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)

---
