import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onSelectPage;
  final Future<void> Function(BuildContext context, String routeName)? navigateSafely;

  const MainDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectPage,
    this.navigateSafely,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset(
                      'assets/icons/home_logo.png', 
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Menu',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildTile(
              icon: Icons.home,
              label: 'Inicio',
              index: 0,
              context: context,
              routeName: '/home',
            ),
            _buildTile(
              icon: Icons.person,
              label: 'Perfil',
              index: 1,
              context: context,
              routeName: '/profile',
            ),
            _buildTile(
              icon: Icons.settings,
              label: 'Preferencias',
              index: 2,
              context: context,
              routeName: '/preferences',
            ),
            _buildTile(
              icon: Icons.favorite,
              label: 'Favoritos',
              index: 3,
              context: context,
              routeName: '/favorites',
            ),
            _buildTile(
              icon: Icons.info_outline,
              label: 'Acerca de',
              index: 4,
              context: context,
              routeName: '/about',
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
    required String routeName,
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
      onTap: () async {
        Navigator.pop(context); // Cierra el drawer

        if (!isSelected) {
          if (navigateSafely != null) {
            await navigateSafely!(context, routeName);
          } else {
            onSelectPage(index);
          }
        }
      },
    );
  }
}
