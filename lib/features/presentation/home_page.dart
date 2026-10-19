import 'package:flutter/material.dart';

import 'assignment_page.dart';
import 'attendance_page.dart';
import 'cgpa_page.dart';
import 'gpa_page.dart';
import 'login.dart';
import 'notes_page.dart';
import 'notifications_page.dart';
import 'saved_page.dart';
import 'settings_page.dart';
import 'student_profile_page.dart';
import 'timetable_page.dart';

const Color primaryBlue = Color(0xFF0B3473);
const Color backgroundColor = Color(0xFFF7F9FC);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeDashboard(),
    ExplorePage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE3EDFF),
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================================================
// HOME DASHBOARD
// ==================================================

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  static const List<Map<String, dynamic>> quickAccess = [
    {
      'title': 'Attendance',
      'icon': Icons.fact_check_rounded,
      'color': Color(0xFFE3EDFF),
    },
    {
      'title': 'Timetable',
      'icon': Icons.calendar_month_rounded,
      'color': Color(0xFFE2F7ED),
    },
    {
      'title': 'Assignments',
      'icon': Icons.assignment_rounded,
      'color': Color(0xFFFFEBD9),
    },
    {
      'title': 'Notes',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFFF0E5FF),
    },
    {
      'title': 'GPA Calculator',
      'icon': Icons.calculate_rounded,
      'color': Color(0xFFE3EDFF),
    },
    {
      'title': 'CGPA Calculator',
      'icon': Icons.school_rounded,
      'color': Color(0xFFE2F7ED),
    },
    {
      'title': 'Saved',
      'icon': Icons.bookmark_rounded,
      'color': Color(0xFFFFEBD9),
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_rounded,
      'color': Color(0xFFF0E5FF),
    },
  ];

  void openPage(BuildContext context, String title) {
    late final Widget page;

    switch (title) {
      case 'Attendance':
        page = const AttendancePage();
        break;

      case 'Timetable':
        page = const TimetablePage();
        break;

      case 'Assignments':
        page = const AssignmentPage();
        break;

      case 'Notes':
        page = const NotesPage();
        break;

      case 'GPA Calculator':
        page = const GpaPage();
        break;

      case 'CGPA Calculator':
        page = const CgpaPage();
        break;

      case 'Saved':
        page = const SavedPage();
        break;

      case 'Settings':
        page = const SettingsPage();
        break;

      case 'Explore':
        page = const ExplorePage();
        break;

      case 'My Activity':
        page = const MyActivityPage();
        break;

      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Nexora',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
              IconButton(
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const StudentProfilePage(),
                    ),
                  );
                },
                icon: const CircleAvatar(
                  backgroundColor: Color(0xFFE3EDFF),
                  child: Icon(Icons.person_rounded, color: primaryBlue),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Welcome to Nexora 👋',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Your academic life, organised in one place.',
            style: TextStyle(fontSize: 15, color: Color(0xFF7B8798)),
          ),

          const SizedBox(height: 26),

          // Welcome card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF164A9C), Color(0xFF0B3473)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.rocket_launch_rounded,
                  size: 43,
                  color: Colors.white,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Your student life starts here!',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage attendance, organise assignments, '
                  'save notes and track your academic progress.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => openPage(context, 'Attendance'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Track attendance  →',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Your student tools',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Choose a feature to get started.',
            style: TextStyle(fontSize: 14, color: Color(0xFF7B8798)),
          ),

          const SizedBox(height: 18),

          // Feature cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quickAccess.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final item = quickAccess[index];

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => openPage(context, item['title'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEDF0F5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: item['color'] as Color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: primaryBlue,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF26364D),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                          color: Color(0xFF7B8798),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ==================================================
// MY ACTIVITY
// ==================================================

class MyActivityPage extends StatelessWidget {
  const MyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('My Activity'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'My Activity',
              subtitle: 'Your recent activity in one place',
              icon: Icons.dashboard_rounded,
            ),
            SizedBox(height: 28),
            EmptyStateCard(
              icon: Icons.history_rounded,
              title: 'No activity yet',
              message: 'Your recent activities will appear here.',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// EXPLORE
// ==================================================

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Attendance',
      'subtitle': 'Track your class attendance',
      'icon': Icons.fact_check_rounded,
    },
    {
      'title': 'Assignments',
      'subtitle': 'Organise your academic deadlines',
      'icon': Icons.assignment_rounded,
    },
    {
      'title': 'Study Notes',
      'subtitle': 'Keep your study notes organised',
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Timetable',
      'subtitle': 'Manage your daily classes',
      'icon': Icons.calendar_month_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeader(
            title: 'Explore Nexora',
            subtitle: 'Access your student tools',
            icon: Icons.explore_rounded,
          ),
          const SizedBox(height: 24),
          ...categories.map((category) {
            return Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE3EDFF),
                  child: Icon(category['icon'] as IconData, color: primaryBlue),
                ),
                title: Text(category['title'] as String),
                subtitle: Text(category['subtitle'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  final title = category['title'] as String;

                  Widget page;

                  switch (title) {
                    case 'Attendance':
                      page = const AttendancePage();
                      break;
                    case 'Assignments':
                      page = const AssignmentPage();
                      break;
                    case 'Study Notes':
                      page = const NotesPage();
                      break;
                    default:
                      page = const TimetablePage();
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => page),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ==================================================
// PAGE HEADER
// ==================================================

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFE3EDFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: primaryBlue, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Color(0xFF7B8798)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================================================
// SAVED
// ==================================================

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final List<String> savedItems = [];
  final TextEditingController controller = TextEditingController();

  void addSavedItem() {
    final value = controller.text.trim();

    if (value.isEmpty) return;

    setState(() {
      savedItems.add(value);
      controller.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item saved successfully')));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Saved'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const PageHeader(
              title: 'Saved Items',
              subtitle: 'Keep important things together',
              icon: Icons.bookmark_rounded,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter an item to save',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: addSavedItem,
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    color: primaryBlue,
                  ),
                ),
              ),
              onSubmitted: (_) => addSavedItem(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: savedItems.isEmpty
                  ? const EmptyStateCard(
                      icon: Icons.bookmark_border_rounded,
                      title: 'Nothing saved yet',
                      message: 'Add an item above to see it here.',
                    )
                  : ListView.builder(
                      itemCount: savedItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: const Icon(
                              Icons.bookmark_rounded,
                              color: primaryBlue,
                            ),
                            title: Text(savedItems[index]),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  savedItems.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// SETTINGS
// ==================================================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeader(
            title: 'Settings',
            subtitle: 'Manage your app preferences',
            icon: Icons.settings_rounded,
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.white,
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_active_outlined,
                color: primaryBlue,
              ),
              title: const Text('Notifications'),
              subtitle: const Text('Enable app notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          Card(
            color: Colors.white,
            child: SwitchListTile(
              secondary: const Icon(
                Icons.dark_mode_outlined,
                color: primaryBlue,
              ),
              title: const Text('Dark mode preference'),
              subtitle: const Text('Save your preferred display setting'),
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Dark mode preference enabled'
                          : 'Dark mode preference disabled',
                    ),
                  ),
                );
              },
            ),
          ),
          const Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.info_outline_rounded, color: primaryBlue),
              title: Text('About Nexora'),
              subtitle: Text('Version 1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================
// PROFILE
// ==================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFFE3EDFF),
                  child: Icon(
                    Icons.person_rounded,
                    color: primaryBlue,
                    size: 55,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'My Nexora Profile',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Manage your student information',
                  style: TextStyle(color: Color(0xFF7B8798)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.person_outline, color: primaryBlue),
              title: const Text('Personal information'),
              subtitle: const Text('View and update your profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const StudentProfilePage(),
                  ),
                );
              },
            ),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.bookmark_outline, color: primaryBlue),
              title: const Text('Saved items'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const SavedPage()),
                );
              },
            ),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.settings_outlined, color: primaryBlue),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================
// NOTIFICATIONS
// ==================================================

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'Notifications',
              subtitle: 'Stay updated with Nexora',
              icon: Icons.notifications_rounded,
            ),
            SizedBox(height: 28),
            EmptyStateCard(
              icon: Icons.notifications_none_rounded,
              title: 'You are all caught up!',
              message: 'New notifications will appear here.',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// EMPTY STATE
// ==================================================

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDF0F5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 52, color: const Color(0xFF9AAFD1)),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF7B8798),
            ),
          ),
        ],
      ),
    );
  }
}
