# Meal Planner — Feature Traceability Matrix

Maps each user-facing feature from OBJECTIVES.md through specification, tests, implementation, and release verification.

---

## Traceability Chain

```
OBJECTIVES.md (product description)
    → docs/SPECIFICATION.md / docs/ARCHITECTURE.md (specification)
    → docs/WORKFLOWS.md (primary user journeys and screen map)
        → frontend/app/meals_app/test/ — widget tests
        → frontend/app/meals_app/integration_test/app_test.dart — end-to-end workflow tests
            → Source implementation
                → docs/DEPLOYMENT.md smoke test (release gate)
```

---

## Development Status Note

Meal Planner is at MVP stage. The backend (FastAPI, port 8010) has meal plan retrieval and health endpoints implemented. The Flutter frontend has a home screen, login, and weekly preview. Full CRUD, recipe management, and shopping lists are in progress.

---

## FR-1 · Meal Planning

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-1.1 | Create weekly meal plans with daily meals | OBJECTIVES.md FR-1.1 | `widget_test` (smoke) | `frontend/packages/meals_ui/lib/screens/meals_home_screen.dart` · `frontend/packages/meals_ui/lib/services/meals_api_service.dart` | Weekly meal plan loads |
| FR-1.2 | Support meal types: breakfast, lunch, dinner, snack | OBJECTIVES.md FR-1.2 | None — gap | `frontend/packages/meals_ui/lib/ui_components/meal_card.dart` | — |
| FR-1.3 | Copy meals between days | OBJECTIVES.md FR-1.3 | None — gap | Planned | — |
| FR-1.4 | Meal templates for quick planning | OBJECTIVES.md FR-1.4 | None — gap | Planned | — |
| FR-1.5 | Weekly meal preview | OBJECTIVES.md FR-1.1 | None — gap | `frontend/packages/meals_ui/lib/ui_components/weekly_meals_preview.dart` | — |

---

## FR-2 · Nutrition Tracking

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-2.1 | Log meals with nutritional data (calories, protein, carbs, fat) | OBJECTIVES.md FR-2.1 | None — gap | `frontend/packages/meals_ui/lib/ui_components/meal_card.dart` · `frontend/packages/meals_ui/lib/services/meals_api_service.dart` | — |
| FR-2.2 | Set daily macro targets | OBJECTIVES.md FR-2.2 | None — gap | Planned | — |
| FR-2.3 | Calculate daily totals automatically | OBJECTIVES.md FR-2.3 | None — gap | Planned | — |
| FR-2.4 | Weekly nutrition summaries | OBJECTIVES.md FR-2.4 | None — gap | Planned | — |
| FR-2.5 | Visualise macro distribution | OBJECTIVES.md FR-2.5 | None — gap | Planned | — |

---

## FR-3 · Recipe Management

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-3.1 | Add recipes with ingredients and instructions | OBJECTIVES.md FR-3.1 | None — gap | Planned | — |
| FR-3.2 | Calculate nutrition from ingredients | OBJECTIVES.md FR-3.2 | None — gap | Planned | — |
| FR-3.3 | Scale recipes by servings | OBJECTIVES.md FR-3.3 | None — gap | Planned | — |
| FR-3.4 | Categorise recipes | OBJECTIVES.md FR-3.4 | None — gap | Planned | — |
| FR-3.5 | Search and filter recipes | OBJECTIVES.md FR-3.5 | None — gap | Planned | — |

---

## FR-4 · Shopping Lists

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-4.1 | Generate list from weekly meal plan | OBJECTIVES.md FR-4.1 | None — gap | Planned | — |
| FR-4.2 | Consolidate duplicate ingredients | OBJECTIVES.md FR-4.2 | None — gap | Planned | — |
| FR-4.3 | Organise by store section | OBJECTIVES.md FR-4.3 | None — gap | Planned | — |
| FR-4.4 | Mark items as purchased | OBJECTIVES.md FR-4.4 | None — gap | Planned | — |
| FR-4.5 | Share lists with household | OBJECTIVES.md FR-4.5 | None — gap | Planned | — |

---

## FR-5 · Dietary Support

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-5.1 | Define dietary restrictions | OBJECTIVES.md FR-5.1 | None — gap | Planned | — |
| FR-5.2 | Allergen warnings | OBJECTIVES.md FR-5.2 | None — gap | Planned | — |
| FR-5.3 | Filter recipes by diet type | OBJECTIVES.md FR-5.3 | None — gap | Planned | — |
| FR-5.4 | Suggest alternatives for restrictions | OBJECTIVES.md FR-5.4 | None — gap | Planned | — |

---

## Authentication (Cross-cutting)

| Feature | Tests | Implementation | Release Gate |
|---------|-------|----------------|--------------|
| Email/password login | `widget_test` (smoke) | `frontend/packages/meals_ui/lib/screens/login_screen.dart` · `frontend/packages/meals_ui/lib/services/meals_api_service.dart` | Login succeeds |
| App context (API base URL) | None | `frontend/packages/meals_ui/lib/app_context.dart` | — |

---

## Coverage Summary

| FR Group | Sub-features | Tests | Gaps |
|----------|-------------|-------|------|
| FR-1 Meal Planning | 5 | Smoke only | Meal type, copy, templates untested |
| FR-2 Nutrition Tracking | 5 | None | Entire group |
| FR-3 Recipe Management | 5 | None | Entire group — planned |
| FR-4 Shopping Lists | 5 | None | Entire group — planned |
| FR-5 Dietary Support | 4 | None | Entire group — planned |

> **Priority gaps**: This app is pre-MVP on testing. Immediate need: add `meals_home_screen_test` (meal card display, weekly plan loading); add backend pytest tests for `/meals/weekly` endpoint; add `meal_card_test` for nutrition display.

## Integration Test Coverage

`frontend/app/meals_app/integration_test/app_test.dart` covers:
- App loads without crashing
- App renders a Scaffold
- App shows login screen when not authenticated
- Login screen has email and password fields
- Auth check does not crash
- App title displayed when home is visible
- Meal Planning section header visible when home loads
- Refresh icon present on home screen
- Refresh button triggers reload without crashing
- App displays loading state initially then settles
- App handles backend unavailability gracefully
- Pull to refresh gesture does not crash
- App remains stable after multiple pump cycles
- Theme is applied correctly

## Workflow Documentation

Primary user journeys documented in `docs/WORKFLOWS.md`:
- Workflow 1: Authentication (login, logout)
- Workflow 2: Weekly Meal Planning (view, plan, copy meals)
- Workflow 3: Nutrition Tracking (log meals, daily totals, macro targets)
- Workflow 4: Recipe Management (planned)
- Workflow 5: Shopping List (generate, manage)
- Workflow 6: Dietary Support (planned)
- Workflow 7: Workout Planner Integration
- Screen / Route Map
