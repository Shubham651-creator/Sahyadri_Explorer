import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../theme.dart';
import '../main_scaffold.dart';
import '../screens/settings_screen.dart';
import '../screens/onboarding_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out of Sahyadri Explorer?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: AppColors.outline)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Navigate to onboarding screen and remove all previous routes
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Not logged in';

    return Drawer(
      child: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 64, bottom: 24, left: 24, right: 24),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              image: DecorationImage(
                image: const NetworkImage('https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=1000'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryContainer.withValues(alpha: 0.8),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC5bzyJvs1dPbbDGhnGMc8kehdF_lk8bt8PikfStYWkwP4hkilIgY5ahnnc8iZrvonFh1ra3O5VXrKmUTV_LXQ0MO2nWpno1gs87lraETkG6n5gW6oeRXFFr1yD9GfZO3Hffg5cSA6_NtR9WDL3oss8WpLiVtAL4HqLE94TFUMETAgZ1-APnTxlJZ0s0JwA0hjK6jNZyq1oH8rc0ldCk1dTP43UuCkvB7oOvTLyDjowT87qwjJkAJxdT8wDKaOJrb-C2X3mtTokLcA'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sahyadri Explorer',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: const Icon(Symbols.home, color: AppColors.primary),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScaffold()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Symbols.map, color: AppColors.primary),
                  title: const Text('Map View'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScaffold()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Symbols.favorite, color: AppColors.outline),
                  title: const Text('Favorites'),
                  trailing: const Text('Coming Soon', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                  onTap: () {
                    Navigator.pop(context); // Just close for now
                  },
                ),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Symbols.settings, color: AppColors.onSurfaceVariant),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Symbols.info, color: AppColors.onSurfaceVariant),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text('About Sahyadri Explorer'),
                        content: Text('Your companion for discovering the majestic forts and trails of the Western Ghats.\n\nVersion 1.0.0'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout Item at bottom
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Symbols.logout, color: AppColors.error),
              title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              onTap: () => _handleLogout(context),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
