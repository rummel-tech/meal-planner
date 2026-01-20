# Meal Planner Deployment

## Overview

This guide covers deploying the Meal Planner frontend and backend.

## Frontend Deployment

### GitHub Pages (via Infrastructure)

```bash
gh workflow run deploy-meal-planner-frontend.yml \
  --repo rummel-tech/infrastructure
```

### Manual Build

```bash
cd modules/planners/meal-planner
flutter build web --release
# Deploy build/web/ to hosting provider
```

## Backend Deployment

### AWS ECS (via Infrastructure)

```bash
gh workflow run deploy-meal-planner-backend.yml \
  --repo rummel-tech/infrastructure
```

### Local Development

```bash
cd services/meal-planner
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8010
```

## Environment Configuration

### Frontend

Pass API URL at build time:
```bash
flutter build web --dart-define=PRODUCTION_API_URL=https://api.example.com
```

### Backend

Create `.env` file:
```bash
DATABASE_URL=postgresql://user:pass@host:5432/meal_planner
SECRET_KEY=your-secret-key
CORS_ORIGINS=https://frontend.example.com
```

## Verification

1. Check backend health: `curl http://localhost:8010/health`
2. Open frontend in browser
3. Verify API connectivity

---

[Back to Module](../) | [Platform Documentation](../../../../docs/)
