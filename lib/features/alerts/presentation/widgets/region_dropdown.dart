// Велике дякую за код складного віджету))

/*-----------------------------------------------------------------------------
  WIDGET
  
  RegionDropdown є перевикористовуваним віджетом для вибору області або окремого
міста зі списку Region.values.

  Я зовсім трішки змінив його, для такого ж відображення, яке було у дизайні
Figma (декілька рядків, залишив коментарі). 
-----------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({
    this.onSelected,
    this.initialSelection,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<Region?>? onSelected;
  final Region? initialSelection;
  final bool enabled;

  static const String _searchIconPath = 'assets/images/icons/icons_search.png';

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
        enabled: enabled,
        // розтягує dropdown до ширини батьківського SizedBox (для центрування):
        expandedInsets: EdgeInsets.zero,
        // щоб список не починався від самого верху, а був більш зручно розташ:
        menuHeight: 280,
        // зміщення списку вниз на 8 логічних пікселів:
        alignmentOffset: const Offset(0, 8),
        initialSelection: initialSelection,
        enableSearch: true,
        enableFilter: true,
        requestFocusOnTap: true,
        hintText: 'Оберіть місто або регіон',
        leadingIcon: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Image.asset(
              _searchIconPath,
              width: 21,
              height: 21,
              fit: BoxFit.contain,
            ),
          ),
        ),
        textStyle: GoogleFonts.kameron(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF5D5D5D),
        ),
        onSelected: onSelected,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.7),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
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
          hintStyle: GoogleFonts.kameron(
            color: const Color(0xFF5D5D5D),
            fontSize: 14,
            fontWeight: FontWeight.w400,
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
