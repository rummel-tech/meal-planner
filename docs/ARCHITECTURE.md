# Meal Planner Architecture

## Overview

The Meal Planner is a Flutter application for nutrition planning and meal tracking, supported by a Python/FastAPI backend service.

## System Components

```
┌─────────────────────┐
│   Flutter App       │
│   (meal-planner)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   FastAPI Service   │
│   (port 8010)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   PostgreSQL/SQLite │
└─────────────────────┘
```

## Frontend Architecture

### Package Structure

```
meal-planner/
├── lib/
│   ├── main.dart           # App entry point
│   ├── config/             # Environment configuration
│   ├── models/             # Data models
│   ├── services/           # API services
│   └── screens/            # UI screens
├── packages/               # Feature packages (if modular)
└── test/                   # Unit tests
```

### Key Components

- **Meal Scheduler**: Weekly meal planning interface
- **Recipe Manager**: Recipe CRUD operations
- **Nutrition Tracker**: Macro and calorie tracking
- **Shopping List**: Generated from meal plans

## Backend Architecture

### Service Structure

```
services/meal-planner/
├── main.py                 # FastAPI app
├── routers/                # API endpoints
├── models/                 # Pydantic models
├── database.py             # Database operations
└── tests/                  # Pytest suite
```

### Key Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/meals` | GET/POST | Meal CRUD |
| `/recipes` | GET/POST | Recipe CRUD |
| `/nutrition` | GET | Nutrition data |
| `/shopping-list` | GET | Generate list |

## Data Models

### Meal
- id, name, type (breakfast/lunch/dinner/snack)
- scheduled_date, recipe_id
- nutritional_info

### Recipe
- id, name, ingredients, instructions
- prep_time, cook_time
- nutritional_info, servings

## Related Documentation

- [Module README](../README.md)
- [Service README](../../../../services/meal-planner/README.md)
- [Platform Architecture](../../../../docs/ARCHITECTURE.md)

---

[Back to Module](../) | [Platform Documentation](../../../../docs/)
