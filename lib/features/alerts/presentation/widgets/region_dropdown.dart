import 'package:flutter/material.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({
    this.onSelected,
    this.initialSelection,
    super.key,
  });

  final ValueChanged<Region?>? onSelected;
  final Region? initialSelection;

  static const _entryStyle = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(Colors.black87),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(14));

    return SizedBox(
      width: double.infinity,
      child: DropdownMenu<Region>(
        initialSelection: initialSelection,
        enableSearch: true,
        enableFilter: true,
        requestFocusOnTap: true,
        hintText: 'Оберіть місто або регіон',
        leadingIcon: const Icon(Icons.search, color: Color(0xFF8BB8D6)),
        textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
        onSelected: onSelected,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.7),
          border: border,
          enabledBorder: border.copyWith(
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
          ),
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.4),
            fontSize: 16,
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          elevation: const WidgetStatePropertyAll(8),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        dropdownMenuEntries: Region.values
            .map(
              (region) => DropdownMenuEntry<Region>(
                value: region,
                label: region.label,
                style: _entryStyle,
              ),
            )
            .toList(),
      ),
    );
  }
}
