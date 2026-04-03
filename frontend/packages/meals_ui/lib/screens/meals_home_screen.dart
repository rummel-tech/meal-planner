import 'package:flutter/material.dart';
import 'package:rummel_blue_theme/rummel_blue_theme.dart';
import '../services/meals_api_service.dart';
import '../ui_components/meal_card.dart';
import '../ui_components/weekly_meals_preview.dart';

class MealsHomeScreen extends StatefulWidget {
  final String userId;
  final VoidCallback? onLogout;

  const MealsHomeScreen({super.key, required this.userId, this.onLogout});

  @override
  State<MealsHomeScreen> createState() => _MealsHomeScreenState();
}

class _MealsHomeScreenState extends State<MealsHomeScreen> {
  final _apiService = MealsApiService();
  bool _loadingWeekly = true;
  bool _loadingToday = true;
  String? _weeklyError;
  String? _todayError;
  Map<String, dynamic>? _weeklyPlan;
  Map<String, dynamic>? _todayMeals;

  @override
  void initState() {
    super.initState();
    _loadWeeklyPlan();
    _loadTodayMeals();
  }

  Future<void> _loadWeeklyPlan() async {
    setState(() {
      _loadingWeekly = true;
      _weeklyError = null;
    });
    try {
      final plan = await _apiService.getWeeklyMealPlan(widget.userId);
      setState(() {
        _weeklyPlan = plan;
        _loadingWeekly = false;
      });
    } catch (e) {
      setState(() {
        _weeklyError = 'Unable to load weekly plan. Please try again.';
        _loadingWeekly = false;
      });
    }
  }

  Future<void> _loadTodayMeals() async {
    setState(() {
      _loadingToday = true;
      _todayError = null;
    });
    try {
      final meals = await _apiService.getTodayMeals(widget.userId);
      setState(() {
        _todayMeals = meals;
        _loadingToday = false;
      });
    } catch (e) {
      setState(() {
        _todayError = 'Unable to load today\'s meals. Please try again.';
        _loadingToday = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _loadWeeklyPlan();
              _loadTodayMeals();
            },
          ),
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: widget.onLogout,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _loadWeeklyPlan(),
            _loadTodayMeals(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(RummelBlueSpacing.base),
          children: [
            Card(
              elevation: 1,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                title: const Text('Meal Planning'),
                subtitle: const Text('Your personalized nutrition guide'),
              ),
            ),
            const SizedBox(height: RummelBlueSpacing.base),
            Text(
              'Today\'s Meals',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: RummelBlueSpacing.gapNormal),
            if (_loadingToday)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(RummelBlueSpacing.lg),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_todayError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
                  child: Column(
                    children: [
                      Text(
                        'Error loading today\'s meals',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: RummelBlueColors.error700,
                            ),
                      ),
                      const SizedBox(height: RummelBlueSpacing.gapNormal),
                      Text(
                        _todayError!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else if (_todayMeals != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;

                  if (isWideScreen) {
                    // Desktop/tablet layout: side by side
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTodayMealsCard(),
                        ),
                        const SizedBox(width: RummelBlueSpacing.base),
                        Expanded(
                          flex: 1,
                          child: _buildTodayStats(),
                        ),
                      ],
                    );
                  } else {
                    // Mobile layout: stacked
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTodayMealsCard(),
                        const SizedBox(height: RummelBlueSpacing.base),
                        _buildTodayStats(),
                      ],
                    );
                  }
                },
              ),
            const SizedBox(height: RummelBlueSpacing.lg),
            if (_loadingWeekly)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(RummelBlueSpacing.lg),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_weeklyError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
                  child: Column(
                    children: [
                      Text(
                        'Error loading weekly plan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: RummelBlueColors.error700,
                            ),
                      ),
                      const SizedBox(height: RummelBlueSpacing.gapNormal),
                      Text(
                        _weeklyError!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else if (_weeklyPlan != null)
              WeeklyMealsPreview(
                weeklyPlan: _weeklyPlan!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeeklyMealsDetailScreen(
                        weeklyPlan: _weeklyPlan!,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMealsCard() {
    final meals = _todayMeals?['meals'] as List<dynamic>? ?? [];
    final dayName = _todayMeals?['day'] ?? 'Today';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: RummelBlueSpacing.base),
            ...meals.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: RummelBlueSpacing.gapNormal),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal['name'] ?? 'Unknown',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: RummelBlueSpacing.gapTight),
                          if (meal['calories'] != null)
                            Text(
                              '${meal['calories']} kcal',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: RummelBlueColors.neutral600,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    if (meal['protein_g'] != null || meal['carbs_g'] != null || meal['fat_g'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (meal['protein_g'] != null)
                            Text(
                              'P: ${meal['protein_g']}g',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (meal['carbs_g'] != null)
                            Text(
                              'C: ${meal['carbs_g']}g',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (meal['fat_g'] != null)
                            Text(
                              'F: ${meal['fat_g']}g',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats() {
    final meals = _todayMeals?['meals'] as List<dynamic>? ?? [];
    final totalCalories = meals.fold<int>(
      0,
      (sum, meal) => sum + ((meal['calories'] ?? 0) as int),
    );
    final totalProtein = meals.fold<int>(
      0,
      (sum, meal) => sum + ((meal['protein_g'] ?? 0) as int),
    );
    final totalCarbs = meals.fold<int>(
      0,
      (sum, meal) => sum + ((meal['carbs_g'] ?? 0) as int),
    );
    final totalFat = meals.fold<int>(
      0,
      (sum, meal) => sum + ((meal['fat_g'] ?? 0) as int),
    );

    return Card(
      color: RummelBlueColors.primary50,
      child: Padding(
        padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Totals',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: RummelBlueSpacing.gapNormal),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statColumn('Calories', totalCalories.toString(), 'kcal'),
                if (totalProtein > 0)
                  _statColumn('Protein', totalProtein.toString(), 'g'),
                if (totalCarbs > 0)
                  _statColumn('Carbs', totalCarbs.toString(), 'g'),
                if (totalFat > 0)
                  _statColumn('Fat', totalFat.toString(), 'g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: RummelBlueColors.neutral600,
              ),
        ),
        const SizedBox(height: RummelBlueSpacing.gapTight),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: RummelBlueColors.neutral600,
              ),
        ),
      ],
    );
  }
}

class WeeklyMealsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> weeklyPlan;

  const WeeklyMealsDetailScreen({super.key, required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    final days = weeklyPlan['days'] as List<dynamic>? ?? [];
    final focus = weeklyPlan['focus'] as String? ?? 'balanced';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Plan'),
      ),
      body: Column(
        children: [
          // Header card with focus
          Padding(
            padding: const EdgeInsets.all(RummelBlueSpacing.base),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plan Focus',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Chip(
                      label: Text(focus),
                      backgroundColor: RummelBlueColors.primary100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Horizontal scrollable day cards
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: RummelBlueSpacing.base),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final dayName = day['day'] as String? ?? '';
                final meals = day['meals'] as List<dynamic>? ?? [];

                return Container(
                  width: 350,
                  margin: const EdgeInsets.only(right: RummelBlueSpacing.base),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: RummelBlueSpacing.md),
                          Expanded(
                            child: ListView(
                              children: meals.map((meal) {
                                return MealCard(
                                  name: meal['name'] ?? 'Unknown',
                                  calories: meal['calories'],
                                  proteinG: meal['protein_g'],
                                  carbsG: meal['carbs_g'],
                                  fatG: meal['fat_g'],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: RummelBlueSpacing.base),
        ],
      ),
    );
  }
}
