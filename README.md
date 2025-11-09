# Distributed Notification System - Setup Guide

A scalable microservices-based notification system built with Python FastAPI, supporting email and push notifications with message queue architecture.

---

## 📋 Table of Contents

- Architecture Overview
- Tech Stack
- Project Structure
- Prerequisites
- Quick Start
- Manual Setup
- Development Workflow
- Testing
- Docker Commands
- Service Documentation
- Team Structure
- Troubleshooting

---

## 🏗️ Architecture Overview

This system consists of **5 microservices** communicating asynchronously through RabbitMQ:

```
Client Request
      ↓
API Gateway (validates & routes)
      ↓
RabbitMQ (message broker)
      ↓
├── Email Service → SMTP/SendGrid
└── Push Service → FCM/OneSignal
      ↓
Template Service (renders templates)
User Service (manages user data)
```

### Key Components:

- **API Gateway**: Entry point, authentication, routing
- **User Service**: User data and preferences
- **Email Service**: Email notification processing
- **Push Service**: Push notification handling
- **Template Service**: Template management and rendering
- **RabbitMQ**: Asynchronous message queue
- **Redis**: Caching and session management
- **PostgreSQL**: Persistent data storage

---

## 🛠️ Tech Stack

| Component            | Technology                 |
| -------------------- | -------------------------- |
| **Framework**        | FastAPI 0.104+             |
| **Language**         | Python 3.11+               |
| **Database**         | PostgreSQL 15              |
| **Cache**            | Redis 7                    |
| **Message Queue**    | RabbitMQ 3                 |
| **Containerization** | Docker & Docker Compose    |
| **Testing**          | Pytest                     |
| **Code Quality**     | Black, Flake8, isort, MyPy |

---

## 📁 Project Structure

```
distributed-notification-system/
├── services/
│   ├── api-gateway/
│   │   ├── src/
│   │   │   ├── api/           # API routes
│   │   │   ├── core/          # Core functionality
│   │   │   ├── models/        # Database models
│   │   │   ├── schemas/       # Pydantic schemas
│   │   │   ├── services/      # Business logic
│   │   │   ├── utils/         # Utilities
│   │   │   ├── config.py      # Configuration
│   │   │   └── main.py        # FastAPI app
│   │   ├── tests/
│   │   ├── requirements.txt
│   │   ├── Dockerfile
│   │   └── README.md
│   ├── user-service/          # Similar structure
│   ├── email-service/         # Similar structure
│   ├── push-service/          # Similar structure
│   └── template-service/      # Similar structure
├── shared/
│   ├── config.py              # Shared configuration
│   ├── schemas/               # Shared schemas
│   │   └── response.py        # Standard API response
│   ├── utils/                 # Shared utilities
│   │   └── logger.py          # Logging setup
│   ├── constants/             # Constants
│   └── requirements-base.txt  # Common dependencies
├── infrastructure/
│   ├── docker/
│   ├── scripts/
│   │   └── setup.sh           # Automated setup script
│   └── kubernetes/            # K8s configs (future)
├── docs/
│   ├── api-specs/             # OpenAPI specs
│   ├── diagrams/              # Architecture diagrams
│   └── guides/                # Development guides
├── tests/
│   ├── integration/           # Integration tests
│   └── e2e/                   # End-to-end tests
├── .env.example               # Environment template
├── .gitignore
├── docker-compose.yml         # Docker orchestration
├── docker-compose.dev.yml     # Development overrides
├── pytest.ini                 # Pytest configuration
├── README.md                  # This file
└── CONTRIBUTING.md            # Contribution guidelines
```

---

## ✅ Prerequisites

Before starting, ensure you have the following installed:

- **Python 3.11+** - [Download](https://www.python.org/downloads/)
- **Docker** - [Download](https://www.docker.com/get-started)
- **Docker Compose** - [Download](https://docs.docker.com/compose/install/)
- **Git** - [Download](https://git-scm.com/downloads)

### Verify Installation

```bash
python3 --version   # Should be 3.11 or higher
docker --version    # Should show Docker version
docker-compose --version  # Should show Docker Compose version
git --version       # Should show Git version
```

---

## 🚀 Quick Start

### Automated Setup (Recommended)

The fastest way to get started is using the automated setup script:

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd distributed-notification-system

# 2. Make setup script executable
chmod +x infrastructure/scripts/setup.sh

# 3. Run the setup script
./infrastructure/scripts/setup.sh
```

**What the script does:**

- ✅ Checks if prerequisites are installed
- ✅ Creates .env file from template
- ✅ Creates Python virtual environment
- ✅ Installs shared dependencies
- ✅ Builds and starts all Docker services
- ✅ Waits for services to be healthy
- ✅ Displays service URLs and useful commands

### Access Services

Once setup completes, access:

| Service             | URL                        | Description                    |
| ------------------- | -------------------------- | ------------------------------ |
| API Gateway         | http://localhost:8000      | Main API entry point           |
| API Gateway Docs    | http://localhost:8000/docs | Swagger UI                     |
| User Service        | http://localhost:8001/docs | User management API            |
| Email Service       | http://localhost:8002/docs | Email service API              |
| Push Service        | http://localhost:8003/docs | Push service API               |
| Template Service    | http://localhost:8004/docs | Template management API        |
| RabbitMQ Management | http://localhost:15672     | Queue management (guest/guest) |

---

## 🔧 Manual Setup

If you prefer manual setup or need more control:

### Step 1: Clone Repository

```bash
git clone <your-repo-url>
cd distributed-notification-system
```

### Step 2: Environment Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your actual values
nano .env  # or use any text editor
```

**Important variables to update:**

- Database passwords
- JWT secret keys
- SMTP/SendGrid credentials
- Firebase/OneSignal API keys

### Step 3: Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate     # Windows

# Upgrade pip
pip install --upgrade pip
```

### Step 4: Install Shared Dependencies

```bash
# Install base requirements (if available)
pip install -r shared/requirements-base.txt
```

### Step 5: Start Docker Services

```bash
# Build and start all services
docker-compose up --build -d

# View logs
docker-compose logs -f

# Check service status
docker-compose ps
```

### Step 6: Verify Services

```bash
# Check if all services are running
curl http://localhost:8000/health
curl http://localhost:8001/health
curl http://localhost:8002/health
curl http://localhost:8003/health
curl http://localhost:8004/health
```

---

## 💻 Development Workflow

### Running Services Locally (Without Docker)

For development, you can run services locally:

```bash
# Navigate to a service
cd services/api-gateway

# Install service dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Run the service with hot reload
uvicorn src.main:app --reload --port 8000

# In another terminal, run another service
cd services/user-service
uvicorn src.main:app --reload --port 8001
```

### Using Docker for Development

For full microservices experience:

```bash
# Start all services with hot reload
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Start specific service
docker-compose up api-gateway

# Rebuild specific service
docker-compose up --build email-service

# View logs for specific service
docker-compose logs -f push-service
```

### Troubleshooting Commands

```bash
# Remove all stopped containers
docker-compose rm

# Rebuild without cache
docker-compose build --no-cache

# Pull latest images
docker-compose pull

# Show resource usage
docker stats

# Inspect service
docker-compose exec api-gateway env
```

---

## 📚 Service Documentation

Each service has auto-generated Swagger/OpenAPI documentation:

### API Gateway (`http://localhost:8000/docs`)

- Authentication endpoints
- Notification submission
- Status tracking

### User Service (`http://localhost:8001/docs`)

- User registration/login
- Profile management
- Notification preferences

### Email Service (`http://localhost:8002/docs`)

- Email processing status
- Retry management
- Health checks

### Push Service (`http://localhost:8003/docs`)

- Push notification status
- Device token management
- Health checks

### Template Service (`http://localhost:8004/docs`)

- Template CRUD operations
- Template rendering
- Version management

## 🤝 Contributing

See CONTRIBUTING.md for detailed contribution guidelines.

---

## 📄 License

MIT License - See LICENSE file for details.

---

## 💬 Support

- Create an issue in GitHub
- Contact team lead
- Check documentation in docs folder

---

**Happy Coding! 🎉**
