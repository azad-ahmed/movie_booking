import 'package:flutter/material.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/settings_item.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  
  // Beispiel-Benutzerdaten
  final Map<String, dynamic> _userProfile = {
    'name': 'Max Mustermann',
    'email': 'max@moviebook.ch',
    'memberSince': 'März 2024',
    'totalBookings': 23,
    'favoriteGenre': 'Action',
    'savedMoney': 89.50,
    'avatar': null, // Placeholder für Avatar
  };

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );
    
    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentController, curve: Curves.easeOut));
    
    _headerController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.green.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header mit Profil Info
              SliverToBoxAdapter(
                child: ScaleTransition(
                  scale: _headerAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar und Name
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Colors.purple,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _userProfile['name'].toString().split(' ')
                                  .map((name) => name[0])
                                  .take(2)
                                  .join(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Name und Email
                        Text(
                          _userProfile['name'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        
                        SizedBox(height: 5),
                        
                        Text(
                          _userProfile['email'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                        
                        SizedBox(height: 10),
                        
                        // Mitglied seit
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Mitglied seit ${_userProfile['memberSince']} 🎬',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Statistiken
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileStatsCard(
                        totalBookings: _userProfile['totalBookings'],
                        favoriteGenre: _userProfile['favoriteGenre'],
                        savedMoney: _userProfile['savedMoney'],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 30)),

              // Einstellungen Sektion
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Einstellungen ⚙️',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 15)),

              // Einstellungen Liste
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SettingsItem(
                            icon: Icons.person_rounded,
                            title: 'Profil bearbeiten',
                            subtitle: 'Name, E-Mail und Präferenzen',
                            onTap: () => _showEditProfile(),
                          ),
                          
                          SettingsItem(
                            icon: Icons.notifications_rounded,
                            title: 'Benachrichtigungen',
                            subtitle: 'Push-Nachrichten verwalten',
                            hasSwitch: true,
                            switchValue: _notificationsEnabled,
                            onSwitchChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                          
                          SettingsItem(
                            icon: Icons.dark_mode_rounded,
                            title: 'Dunkler Modus',
                            subtitle: 'App-Design ändern',
                            hasSwitch: true,
                            switchValue: _darkModeEnabled,
                            onSwitchChanged: (value) {
                              setState(() {
                                _darkModeEnabled = value;
                              });
                              // Hier würdest du das Theme ändern
                            },
                          ),
                          
                          SettingsItem(
                            icon: Icons.payment_rounded,
                            title: 'Zahlungsmethoden',
                            subtitle: 'Karten und PayPal verwalten',
                            onTap: () => _showPaymentMethods(),
                          ),
                          
                          SettingsItem(
                            icon: Icons.history_rounded,
                            title: 'Buchungshistorie',
                            subtitle: 'Alle deine vergangenen Buchungen',
                            onTap: () => _showBookingHistory(),
                          ),
                          
                          SettingsItem(
                            icon: Icons.help_rounded,
                            title: 'Hilfe & Support',
                            subtitle: 'FAQ und Kundensupport',
                            onTap: () => _showHelp(),
                          ),
                          
                          SettingsItem(
                            icon: Icons.info_rounded,
                            title: 'Über die App',
                            subtitle: 'Version 1.0.0',
                            onTap: () => _showAbout(),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Abmelden Button
                          Container(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => _showLogoutDialog(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.red.withOpacity(0.3)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Abmelden',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profil bearbeiten'),
        content: Text('Hier würdest du dein Profil bearbeiten können.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Zahlungsmethoden werden geöffnet... 💳'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBookingHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buchungshistorie wird geladen... 📚'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hilfe-Center wird geöffnet... ❓'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Über MovieBook'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Entwickelt mit ❤️ für Filmliebhaber'),
            SizedBox(height: 8),
            Text('© 2025 MovieBook Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Abmelden'),
        content: Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Du wurdest abgemeldet 👋'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Abmelden'),
          ),
        ],
      ),
    );
  }
}