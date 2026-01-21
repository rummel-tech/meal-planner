---
module: meal-planner
version: 1.0.0
status: draft
last_updated: 2026-01-20
---

# Meal Planner Specification

## Overview

The Meal Planner module provides weekly meal planning and nutritional tracking capabilities. It enables users to view their weekly meal plans, track daily nutrition, and manage meals across the week. The module consists of a FastAPI backend (port 8010) with mock data and a Flutter web frontend with Material Design 3 styling.

## Authentication

This module uses the shared AWS Amplify authentication system. See [Authentication Architecture](../../../../docs/architecture/AUTHENTICATION.md) for complete details.

### Authentication Modes

| Mode | Description |
|------|-------------|
| Artemis-Integrated | User authenticates via Artemis, gains access to all permitted modules |
| Standalone | User authenticates directly in Meal Planner app |

### Module Access

- **Module ID**: `meal-planner`
- **Artemis Users**: Full access when `artemis_access: true`
- **Standalone Users**: Access when `meal-planner` in `module_access` list

### Login Screen

Uses shared `auth_ui` package with identical UI to all other modules:
- Email/password authentication
- Google Sign-In
- Apple Sign-In
- Email verification flow
- Password reset flow

### API Authentication

All API endpoints require JWT Bearer token from AWS Cognito:
```http
Authorization: Bearer <access_token>
```

Backend validates tokens using AWS Cognito SDK and checks module access permissions.

## Design System

This module uses the shared Artemis Design System. See [Design System](../../../../docs/architecture/DESIGN_SYSTEM.md) for complete specifications.

### Design Principles

All UI components follow the shared design system to ensure visual consistency across the Artemis ecosystem:

- **Colors**: Rummel Blue primary (`#1E88E5`), Teal secondary (`#26A69A`)
- **Typography**: Material 3 type scale with system fonts
- **Spacing**: Consistent 4dp base unit scale (xs: 4dp, sm: 8dp, md: 16dp, lg: 24dp)
- **Components**: Shared button, card, input, and navigation styles

### Module-Specific Colors

| Element | Color | Hex | Usage |
|---------|-------|-----|-------|
| Protein | Blue | `#1976D2` | Protein macro indicator |
| Carbs | Orange | `#F57C00` | Carbohydrate macro indicator |
| Fat | Yellow | `#FBC02D` | Fat macro indicator |
| Breakfast | Warm Yellow | `#FFB300` | Breakfast meal type badge |
| Lunch | Green | `#43A047` | Lunch meal type badge |
| Dinner | Deep Blue | `#1565C0` | Dinner meal type badge |
| Snack | Teal | `#26A69A` | Snack meal type badge |

### Key Components

| Component | Specification |
|-----------|---------------|
| MealCard | Card with 12dp radius, meal type badge, calorie display |
| DayColumn | Vertical list with day header, meal cards grouped by type |
| NutritionSummary | Horizontal bar chart showing macro distribution |
| MacroChip | Colored chip with macro type icon and gram value |
| WeekSelector | Horizontal date picker matching shared design |
| CalorieRing | Circular progress showing daily calorie target progress |

### Nutrition Display Colors

| Macro | Color | Background |
|-------|-------|------------|
| Protein | `#1976D2` | `#BBDEFB` |
| Carbs | `#F57C00` | `#FFE0B2` |
| Fat | `#FBC02D` | `#FFF9C4` |
| Fiber | `#388E3C` | `#C8E6C9` |

### Screen Layouts

All screens follow responsive breakpoints from the shared design system:
- Mobile (< 600dp): Single column with day tabs, bottom navigation
- Tablet (600-839dp): 2-column day grid, navigation rail optional
- Desktop (>= 840dp): Full week view with 7 columns

## Data Models

### MealItem

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| name | String | Required | Name of the meal or food item |
| calories | int? | Optional, >= 0 | Caloric content |
| protein_g | int? | Optional, >= 0 | Protein in grams |
| carbs_g | int? | Optional, >= 0 | Carbohydrates in grams |
| fat_g | int? | Optional, >= 0 | Fat in grams |

**Indexes (Planned):**
- name (for search)

**JSON Serialization:**
```json
{
  "name": "Oats + Berries",
  "calories": 350,
  "protein_g": 12,
  "carbs_g": 58,
  "fat_g": 8
}
```

### DailyMeals

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| day | String | Required, valid day name | Day of the week (Monday-Sunday) |
| meals | List\<MealItem\> | Default: [] | Meals for the day |

**Computed Properties (Planned):**
- `totalCalories`: Sum of all meal calories
- `totalProtein`: Sum of all meal protein
- `totalCarbs`: Sum of all meal carbs
- `totalFat`: Sum of all meal fat

**Relationships:**
- DailyMeals belongs to WeeklyMealPlan (via days list)
- DailyMeals has many MealItems

**JSON Serialization:**
```json
{
  "day": "Monday",
  "meals": [
    {"name": "Oats + Berries", "calories": 350},
    {"name": "Chicken Salad", "calories": 500},
    {"name": "Salmon + Quinoa + Greens", "calories": 600}
  ]
}
```

### WeeklyMealPlan

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| user_id | String | Required | User identifier |
| week_start | String? | Optional, ISO date | Start date of the week |
| focus | String | Default: "balanced" | Nutritional focus/theme |
| days | List\<DailyMeals\> | Required | 7 days of meals |

**Focus Types:**
| Focus | Description |
|-------|-------------|
| balanced | General healthy eating |
| high_protein | Emphasis on protein-rich meals |
| low_carb | Reduced carbohydrate intake |
| vegetarian | Plant-based meals |
| meal_prep | Batch-cooking friendly |

**Relationships:**
- WeeklyMealPlan has many DailyMeals (7 days)

**Indexes (Planned):**
- user_id (for user-scoped queries)
- week_start (for week lookup)

**JSON Serialization:**
```json
{
  "user_id": "user-123",
  "week_start": "2026-01-20",
  "focus": "balanced",
  "days": [
    {"day": "Monday", "meals": [...]},
    {"day": "Tuesday", "meals": [...]},
    ...
  ]
}
```

### Meal (Planned - Extended Model)

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, UUID | Unique identifier |
| user_id | String | Required | User identifier |
| name | String | Required | Meal name |
| meal_type | String | breakfast/lunch/dinner/snack | Type of meal |
| ingredients | List\<Ingredient\> | Default: [] | Recipe ingredients |
| calories | int? | Optional | Total calories |
| protein_g | int? | Optional | Total protein |
| carbs_g | int? | Optional | Total carbs |
| fat_g | int? | Optional | Total fat |
| recipe_url | String? | Optional | Link to recipe |
| image_url | String? | Optional | Meal photo |
| prep_time_minutes | int? | Optional | Preparation time |
| is_favorite | bool | Default: false | User favorite flag |
| created_at | DateTime | Auto | Creation timestamp |
| updated_at | DateTime | Auto | Last update timestamp |

## Use Cases

### UC-001: View Weekly Meal Plan

**Actor:** User

**Preconditions:**
- User has access to the meal planner

**Flow:**
1. User requests weekly meal plan
2. System retrieves plan for current week (or specified week)
3. System returns plan with all 7 days and meals
4. UI displays days with meal cards

**Postconditions:**
- Weekly plan data displayed

**Acceptance Criteria:**
- [ ] All 7 days are returned
- [ ] Each day includes breakfast, lunch, dinner
- [ ] Nutritional info displayed where available
- [ ] Week start date is shown

### UC-002: View Today's Meals

**Actor:** User

**Preconditions:**
- User has access to the meal planner

**Flow:**
1. User requests today's meals (or specific date)
2. System determines day of week from date
3. System retrieves meals for that day
4. System returns daily meals with nutritional summary

**Postconditions:**
- Today's meals displayed with details

**Acceptance Criteria:**
- [ ] Correct day is identified from date
- [ ] All meals for day are returned
- [ ] Nutritional totals calculated
- [ ] Meal details include name and calories

### UC-003: Create Meal Plan (Planned)

**Actor:** User

**Preconditions:**
- User is authenticated

**Flow:**
1. User selects week and focus type
2. User adds meals for each day
3. User can search/select from meal database
4. User saves the plan
5. System stores plan with user_id

**Postconditions:**
- New meal plan created and stored
- Plan retrievable by week_start

**Acceptance Criteria:**
- [ ] Plan is associated with user
- [ ] All 7 days can have meals assigned
- [ ] Focus type is stored
- [ ] Plan overwrites existing week if present

### UC-004: Edit Meal (Planned)

**Actor:** User

**Preconditions:**
- Meal plan exists for the week

**Flow:**
1. User selects a meal to edit
2. User modifies meal details (name, nutrition)
3. User saves changes
4. System updates the meal

**Postconditions:**
- Meal updated in plan

**Acceptance Criteria:**
- [ ] Meal details can be modified
- [ ] Nutritional values update
- [ ] Changes persist

### UC-005: Track Nutrition (Planned)

**Actor:** User

**Preconditions:**
- User has meals logged

**Flow:**
1. User views nutrition dashboard
2. System aggregates daily/weekly nutrition
3. System compares to targets
4. System displays progress

**Postconditions:**
- Nutrition summary displayed

**Acceptance Criteria:**
- [ ] Daily totals calculated
- [ ] Weekly averages shown
- [ ] Progress toward goals displayed
- [ ] Macros breakdown (protein/carbs/fat)

### UC-006: Generate Shopping List (Planned)

**Actor:** User

**Preconditions:**
- Weekly meal plan exists

**Flow:**
1. User requests shopping list for week
2. System extracts all ingredients from meals
3. System consolidates duplicate items
4. System returns organized shopping list

**Postconditions:**
- Shopping list generated

**Acceptance Criteria:**
- [ ] All meal ingredients included
- [ ] Duplicates combined with quantities
- [ ] List organized by category
- [ ] Exportable/shareable

## UI Workflows

### Screen: Meals Home

**Purpose:** Weekly overview and quick access to today's meals

**Entry Points:**
- Main app navigation
- Dashboard widget

**Components:**
- WeekSelector: Navigate between weeks
- WeeklyMealsPreview: Summary cards for each day
- TodayHighlight: Featured card for today's meals
- NutritionSummary: Weekly calorie/macro totals
- QuickActions: Add meal, view recipes

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| View Day | Day card tap | Navigate to day detail |
| Previous Week | Left arrow | Load previous week |
| Next Week | Right arrow | Load next week |
| View Today | Today button | Scroll to/highlight today |

**Navigation:**
- Day card → Day Detail Screen
- Add meal → Meal Editor (planned)

### Screen: Day Detail (Planned)

**Purpose:** View and edit meals for a specific day

**Entry Points:**
- Meals Home day card tap

**Components:**
- DayHeader: Day name and date
- MealList: Breakfast, lunch, dinner sections
- MealCard: Individual meal with nutrition
- NutritionTotals: Daily macro summary
- AddMealButton: Add meal to day

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Edit Meal | Meal tap | Open meal editor |
| Delete Meal | Swipe/delete | Remove meal |
| Add Meal | Add button | Open meal selector |
| Reorder | Drag handle | Reposition meal |

**Navigation:**
- Back → Meals Home
- Edit → Meal Editor

### Screen: Meal Editor (Planned)

**Purpose:** Create or edit a meal

**Entry Points:**
- Add meal action
- Edit meal action

**Components:**
- NameField: Meal name input
- MealTypeSelector: Breakfast/lunch/dinner/snack
- NutritionInputs: Calories, protein, carbs, fat
- IngredientsList: Searchable ingredient entry
- RecipeLink: Optional URL field
- ImagePicker: Photo upload
- SaveButton: Confirm changes

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Save | Button tap | Save meal, return to day |
| Cancel | Back/cancel | Discard changes |
| Add Ingredient | Search/add | Add to ingredients list |
| Upload Photo | Camera/gallery | Attach image |

**Navigation:**
- Save → Day Detail
- Cancel → Day Detail

## API Specification

### GET /health

**Description:** Health check endpoint

**Authentication:** None

**Response 200:**
```json
{"status": "ok"}
```

### GET /ready

**Description:** Readiness probe

**Authentication:** None

**Response 200:**
```json
{"status": "ready"}
```

### GET /meals/weekly-plan/{user_id}

**Description:** Retrieve weekly meal plan for user

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| week_start | string | current week | ISO date for week start |

**Response 200:**
```json
{
  "user_id": "user-123",
  "week_start": "2026-01-20",
  "focus": "balanced",
  "days": [
    {
      "day": "Monday",
      "meals": [
        {"name": "Oats + Berries", "calories": 350},
        {"name": "Chicken Salad", "calories": 500},
        {"name": "Salmon + Quinoa + Greens", "calories": 600}
      ]
    },
    ...
  ]
}
```

**Error Responses:**
| Code | Condition |
|------|-----------|
| 404 | User not found (planned) |
| 500 | Server error |

### GET /meals/today/{user_id}

**Description:** Get meals for a specific date

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| date | string | today | ISO date (YYYY-MM-DD) |

**Response 200:**
```json
{
  "user_id": "user-123",
  "day": "Monday",
  "meals": [
    {"name": "Oats + Berries", "calories": 350},
    {"name": "Chicken Salad", "calories": 500},
    {"name": "Salmon + Quinoa + Greens", "calories": 600}
  ]
}
```

### POST /meals/weekly-plan/{user_id} (Planned)

**Description:** Create or update weekly meal plan

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "week_start": "string - required, ISO date",
  "focus": "string - optional, default: balanced",
  "days": [
    {
      "day": "string - required",
      "meals": [
        {
          "name": "string - required",
          "calories": "int - optional",
          "protein_g": "int - optional",
          "carbs_g": "int - optional",
          "fat_g": "int - optional"
        }
      ]
    }
  ]
}
```

**Response 201:**
```json
{
  "message": "Meal plan created",
  "week_start": "2026-01-20"
}
```

### PUT /meals/{user_id}/day/{day} (Planned)

**Description:** Update meals for a specific day

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "meals": [
    {"name": "string", "calories": "int", ...}
  ]
}
```

### GET /meals/nutrition/{user_id} (Planned)

**Description:** Get nutrition summary

**Authentication:** Required (JWT Bearer)

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| start_date | string | week start | Start of period |
| end_date | string | today | End of period |

**Response 200:**
```json
{
  "period": {"start": "2026-01-20", "end": "2026-01-26"},
  "daily_averages": {
    "calories": 1800,
    "protein_g": 120,
    "carbs_g": 180,
    "fat_g": 60
  },
  "daily_breakdown": [
    {"date": "2026-01-20", "calories": 1850, ...}
  ]
}
```

### GET /meals/shopping-list/{user_id} (Planned)

**Description:** Generate shopping list from meal plan

**Authentication:** Required (JWT Bearer)

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| week_start | string | current week | Week to generate list for |

**Response 200:**
```json
{
  "week_start": "2026-01-20",
  "items": [
    {"name": "Chicken breast", "quantity": "2 lbs", "category": "protein"},
    {"name": "Oats", "quantity": "1 container", "category": "grains"},
    {"name": "Mixed berries", "quantity": "2 cups", "category": "produce"}
  ]
}
```

## Implementation Status

### Data Models

| Model | Status | Notes |
|-------|--------|-------|
| MealItem | ✅ Implemented | Pydantic model in backend |
| DailyMeals | ✅ Implemented | Pydantic model in backend |
| WeeklyMealPlan | ✅ Implemented | Pydantic model in backend |
| Meal (extended) | ⬜ Planned | Full meal with ingredients |

### API Endpoints

| Endpoint | Status | Notes |
|----------|--------|-------|
| GET /health | ✅ Implemented | Health check |
| GET /ready | ✅ Implemented | Readiness probe |
| GET /meals/weekly-plan/{user_id} | ✅ Implemented | Returns mock data |
| GET /meals/today/{user_id} | ✅ Implemented | Returns mock data |
| POST /meals/weekly-plan | ⬜ Planned | Create/update plan |
| PUT /meals/{user_id}/day/{day} | ⬜ Planned | Update day |
| GET /meals/nutrition/{user_id} | ⬜ Planned | Nutrition summary |
| GET /meals/shopping-list/{user_id} | ⬜ Planned | Shopping list |

### UI Screens

| Screen | Status | Notes |
|--------|--------|-------|
| Login | ⬜ Planned | Uses shared auth_ui package |
| Register | ⬜ Planned | Uses shared auth_ui package |
| Meals Home | ✅ Implemented | Weekly overview |
| Day Detail | ⬜ Planned | Day-specific view |
| Meal Editor | ⬜ Planned | Create/edit meals |
| Nutrition Dashboard | ⬜ Planned | Tracking view |
| Shopping List | ⬜ Planned | Generated list |

### Authentication

| Component | Status | Notes |
|-----------|--------|-------|
| AWS Amplify Integration | ⬜ Planned | Shared Cognito User Pool |
| Shared auth_ui Package | ⬜ Planned | Login/register screens |
| Token Validation | ⬜ Planned | Backend JWT verification |
| Module Access Control | ⬜ Planned | Cognito custom attributes |

### Frontend Services

| Service | Status | Notes |
|---------|--------|-------|
| MealsApiService | ✅ Implemented | HTTP client |
| getWeeklyMealPlan() | ✅ Implemented | Fetches weekly plan |
| getTodayMeals() | ✅ Implemented | Fetches daily meals |

### Testing

| Component | Status | Notes |
|-----------|--------|-------|
| Backend Unit Tests | ⬜ Planned | |
| Frontend Unit Tests | ⬜ Planned | |
| Integration Tests | ⬜ Planned | |

**Legend:** ✅ Implemented | 🚧 Partial | ⬜ Planned

## Technical Notes

### Backend
- Framework: FastAPI
- Port: 8010
- Root Path: /meal-planner
- Storage: In-memory mock data (no database)
- CORS: Open policy (all origins allowed)

### Frontend
- Framework: Flutter Web
- Package: frontend/packages/meals_ui
- State Management: StatefulWidget with setState()
- API Base URL: Configurable

### Key Implementation Details
- Mock data provides 7 days with 3 meals each
- Calorie data included, macros partially implemented
- Date parsing handles both ISO and YYYY-MM-DD formats
- Day names derived from date using strftime
