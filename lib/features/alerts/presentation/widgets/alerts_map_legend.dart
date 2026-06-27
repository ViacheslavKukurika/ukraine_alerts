/*-----------------------------------------------------------------------------
  WIDGET
  
  Вирішив додати цей віджет, в дизайні його не було.
  
  AlertsMapLegend пояснює користувачеві значення кольорів і прозорості регіонів
на карті.

  Легенда містить три варіанти: повну тривогу, часткову тривогу та відсутність
тривоги. Кожен пункт будується приватним віджетом _LegendItem, який поєднує
кольоровий індикатор і текстовий опис.
-----------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

class AlertsMapLegend extends StatelessWidget {
  const AlertsMapLegend({super.key});

  static const Color _activeColor = Color(0xFFB3261E);
  static const Color _partialColor = Color(0x8CB3261E);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LegendItem(
          color: _activeColor,
          label: 'Тривога в усьому регіоні',
        ),

        SizedBox(height: 12),
        _LegendItem(
          color: _partialColor,
          label: 'Часткова тривога',
        ),

        SizedBox(height: 12),
        _LegendItem(
          color: Colors.transparent,
          borderColor: Colors.grey,
          label: 'Тривоги немає',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.borderColor,
  });

  final Color color;
  final String label;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(label),
        ),
      ],
    );
  }
}
