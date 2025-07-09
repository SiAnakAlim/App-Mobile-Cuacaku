import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// Auth imports
import 'package:fixtugasakhir/auth/auth_service.dart';
import 'package:fixtugasakhir/auth/auth_model.dart';
import 'package:fixtugasakhir/auth/login_screen.dart';
import 'package:fixtugasakhir/auth/register_screen.dart';

// Model imports
import 'package:fixtugasakhir/models/weather_model.dart';
import 'package:fixtugasakhir/models/premium_transaction.dart';

// Screen imports
import 'package:fixtugasakhir/screens/home_screen.dart';
import 'package:fixtugasakhir/screens/profile_screen.dart';
import 'package:fixtugasakhir/screens/feedback_screen.dart';
import 'package:fixtugasakhir/screens/premium_purchase_screen.dart';

// Utils imports
import 'package:fixtugasakhir/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();


  await NotificationService.init();

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(WeatherDataAdapter());
  Hive.registerAdapter(PremiumTransactionAdapter());

  // Initialize auth service
  final authService = AuthService();
  await authService.init();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatefulWidget {
  final AuthService authService;

  const MyApp({Key? key, required this.authService}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      _isLoggedIn = widget.authService.isUserLoggedIn();
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuacaKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.light(
          primary: Colors.amber[800]!,
          secondary: Colors.amber[600]!,
        ),
        scaffoldBackgroundColor: Colors.amber[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber[800],
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[800]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[900]!, width: 3),
          ),
          labelStyle: TextStyle(color: Colors.amber[900]),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[800],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.amber[100],
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.openSans(),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: _isLoggedIn
          ? MainScreen(onLogout: _onLogout, authService: widget.authService)
          : AuthWrapper(onLoginSuccess: _onLoginSuccess),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AuthWrapper({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: showLoginPage
          ? LoginScreen(
        key: const ValueKey('login'),
        onRegisterPressed: toggleScreens,
        onLoginSuccess: widget.onLoginSuccess,
      )
          : RegisterScreen(
        key: const ValueKey('register'),
        onLoginPressed: toggleScreens,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final AuthService authService;

  const MainScreen({Key? key, required this.onLogout, required this.authService}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserEmail();

  }

  void _loadCurrentUserEmail() {
    _currentUserEmail = widget.authService.getLoggedInUserEmail();
    _widgetOptions = <Widget>[
      const HomeScreen(),

      ProfileScreen(currentUserEmail: _currentUserEmail ?? ''),
      const FeedbackScreen(),
      Container(),
    ];
    setState(() {});
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      _showLogoutConfirmationDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Konfirmasi Logout",
            style: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
          ),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await widget.authService.logoutUser();
                widget.onLogout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_currentUserEmail == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CuacaKu'),

      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          const BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}