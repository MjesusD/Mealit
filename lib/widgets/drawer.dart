import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onSelectPage;

  const MainDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: Container(
        color: colorScheme.surfaceContainerLowest,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
              ),
              child: Text(
                'MealIt Menu',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTile(
              icon: Icons.home,
              label: 'Inicio',
              index: 0,
              context: context,
            ),
            _buildTile(
              icon: Icons.person,
              label: 'Perfil',
              index: 1,
              context: context,
            ),
            _buildTile(
              icon: Icons.settings,
              label: 'Preferencias',
              index: 2,
              context: context,
            ),
            _buildTile(
              icon: Icons.favorite,
              label: 'Favoritos',
              index: 3,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurface),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.surfaceContainerHigh,
      onTap: () {
        Navigator.pop(context); // cierra drawer
        if (!isSelected) {
          onSelectPage(index);
        }
      },
    );
  }
}
