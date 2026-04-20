# Meal Planner — Primary Workflows

Documents the main user-facing journeys through the Meal Planner app.

---

## Navigation Structure

App opens to **AuthWrapper**:
- If authenticated → **MealsHomeScreen**
- If not authenticated → **LoginScreen**

**MealsHomeScreen** is the central hub showing:
- Weekly meal plan preview
- Daily nutrition summary
- Quick access to recipes and shopping list

---

## 1. Authentication

### Login
1. Open app → **LoginScreen**
2. Enter email and password → tap **Log In**
3. JWT stored → lands on **MealsHomeScreen**

### Logout
**Entry:** MealsHomeScreen → Settings / profile icon → **Logout**

---

## 2. Weekly Meal Planning (Core Workflow)

### Step 1: View the Weekly Plan
**Entry:** MealsHomeScreen → Weekly Meals Preview

- Shows Mon–Sun with planned meals per day
- Each day slot shows: breakfast, lunch, dinner, snack (or empty)

### Step 2: Plan a Meal
**Entry:** Weekly preview → tap a day slot → **Add Meal**

1. Select meal type: Breakfast, Lunch, Dinner, or Snack
2. Choose from saved recipes or enter a custom meal name
3. Set serving size
4. Meal appears in the day slot with nutritional totals

### Step 3: Copy a Meal to Another Day
**Entry:** Meal card → **Copy to Day**

1. Select target day
2. Meal duplicated; nutrition totals updated

### Step 4: Review Weekly Nutrition
- Weekly plan screen shows daily calorie and macro totals
- Colour coding: green (on target), amber (over/under by 10%), red (significantly off)

---

## 3. Nutrition Tracking

### Log a Meal
**Entry:** MealsHomeScreen → today's meal slot → **Log**

1. Confirm meal was eaten (or adjust serving size)
2. Actual nutrition recorded

### View Daily Totals
- Nutrition summary card on MealsHomeScreen
- Shows: calories, protein, carbs, fat vs. daily targets
- Bar charts for macro distribution

### Set Daily Macro Targets
**Entry:** Settings → **Nutrition Goals**

1. Enter calorie target
2. Enter protein / carb / fat targets (grams)
3. Targets reflected in daily summary

---

## 4. Recipe Management (Planned)

### Add a Recipe
**Entry:** Recipes screen → "+"

1. Enter recipe name and category (cuisine, meal type, diet)
2. Add ingredients with amounts
3. System calculates nutritional totals from ingredient database
4. Add instructions
5. Set servings
6. Save → recipe available for meal planning

### Scale a Recipe
**Entry:** Recipe detail → **Adjust Servings**

- Change serving count → all ingredient amounts and nutrition recalculate

### Search Recipes
- Filter by: meal type, cuisine, dietary restriction (vegan, gluten-free, etc.)
- Search by name or ingredient

---

## 5. Shopping List

### Generate from Meal Plan
**Entry:** MealsHomeScreen → **Shopping List** button

1. System consolidates all ingredients from the week's meal plan
2. Duplicate ingredients merged with quantities summed
3. List organised by store section (produce, dairy, meat, etc.)

### Manage the List
- Tap item → **Mark purchased** (strikethrough)
- Manually add items not on a recipe
- Share list via iOS/Android share sheet

---

## 6. Dietary Support (Planned)

**Entry:** Settings → **Dietary Preferences**

1. Set restrictions: vegan, vegetarian, gluten-free, dairy-free, nut-free, etc.
2. Set allergens
3. Recipe browser filters automatically
4. Allergen warnings appear on non-conforming meals

---

## 7. Workout Planner Integration

- Import daily calorie burn from Workout Planner
- Calorie target on MealsHomeScreen adjusts to account for exercise
- Post-workout meal suggestions based on workout type

---

## 8. Screen / Route Map

| Screen | Purpose |
|--------|---------|
| LoginScreen | Email/password authentication |
| MealsHomeScreen | Weekly plan preview, nutrition summary, quick actions |
| WeeklyPlanScreen | Full 7-day meal planning view |
| MealDetailScreen | View/edit a single meal |
| RecipesScreen | Browse and search saved recipes |
| RecipeDetailScreen | Full recipe with ingredients, instructions, nutrition |
| ShoppingListScreen | Consolidated ingredient list for the week |
| NutritionGoalsScreen | Set daily calorie and macro targets |

---

## 9. Typical Workflow

```
MealsHomeScreen
    → See this week's plan (partial — some days empty)
    → Tap Tuesday dinner slot → Add Meal
        → Select "Chicken Stir Fry" recipe
        → Confirm 2 servings
    → Weekly plan updated; nutrition totals recalculate
    → Tap Shopping List
        → See consolidated ingredient list
        → Mark off items already in pantry
```
