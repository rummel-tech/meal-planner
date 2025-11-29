import 'package:flutter/material.dart';
import 'package:rummel_blue_theme/rummel_blue_theme.dart';

class MealCard extends StatelessWidget {
  final String name;
  final int? calories;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;

  const MealCard({
    super.key,
    required this.name,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: RummelBlueSpacing.gapNormal / 2),
      child: Padding(
        padding: const EdgeInsets.all(RummelBlueSpacing.cardPaddingCompact),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: RummelBlueSpacing.gapTight),
                  if (calories != null)
                    Text(
                      '$calories kcal',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: RummelBlueColors.neutral600,
                          ),
                    ),
                ],
              ),
            ),
            if (proteinG != null || carbsG != null || fatG != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (proteinG != null)
                    Text(
                      'P: ${proteinG}g',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (carbsG != null)
                    Text(
                      'C: ${carbsG}g',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (fatG != null)
                    Text(
                      'F: ${fatG}g',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
