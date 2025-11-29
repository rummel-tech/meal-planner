import 'package:flutter/material.dart';
import 'package:rummel_blue_theme/rummel_blue_theme.dart';

class WeeklyMealsPreview extends StatelessWidget {
  final Map<String, dynamic> weeklyPlan;
  final VoidCallback? onTap;

  const WeeklyMealsPreview({
    super.key,
    required this.weeklyPlan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final days = weeklyPlan['days'] as List<dynamic>? ?? [];
    final focus = weeklyPlan['focus'] as String? ?? 'balanced';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RummelBlueSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Meal Plan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Chip(
                    label: Text(focus),
                    backgroundColor: RummelBlueColors.primary100,
                  ),
                ],
              ),
              const SizedBox(height: RummelBlueSpacing.md),
              ...days.take(3).map((day) {
                final dayName = day['day'] as String? ?? '';
                final meals = day['meals'] as List<dynamic>? ?? [];
                final mealCount = meals.length;
                final totalCalories = meals.fold<int>(
                  0,
                  (sum, meal) => sum + ((meal['calories'] ?? 0) as int),
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: RummelBlueSpacing.gapNormal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '$mealCount meals • $totalCalories kcal',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: RummelBlueColors.neutral600,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (days.length > 3) ...[
                const SizedBox(height: RummelBlueSpacing.gapNormal),
                Center(
                  child: TextButton(
                    onPressed: onTap,
                    child: const Text('View Full Week'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
