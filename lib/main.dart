import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serv_now_new/controllers/admin_provider.dart';
import 'package:serv_now_new/firebase_options.dart';
import 'package:serv_now_new/screens/admin/pending_services.dart';
import 'package:serv_now_new/screens/admin/review_service.dart';
import 'package:serv_now_new/screens/admin/users_page.dart';
import 'controllers/auth_provider.dart';
import 'controllers/create_service_provider.dart';
import 'controllers/details_page_provider.dart';
import 'controllers/home_provider.dart';
import 'controllers/my_adverts_provider.dart';
import 'controllers/profile_proviver.dart';
import 'screens/auth/phone.dart';
import 'screens/auth/verify.dart';
import 'screens/home/boomark_page.dart';
import 'screens/home/create_service_page.dart';
import 'screens/home/home.dart';
import 'screens/home/my_adverts.dart';
import 'screens/home/update_service_page.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile/profile_page.dart';
import 'screens/profile/update_profile_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  AuthService authProvider = AuthService();
  // ProfileProvider proProvider = ProfileProvider();
  // proProvider.saveProfile(
  //     "", "name", "+233249058525", "bio", "email", "img", "", true, []);

  // authProvider.isLogin(true);

  bool userLoggedIn = await authProvider.loginState();

 // String initialRoute = userLoggedIn ? 'home' : 'onBoarding';
String initialRoute = userLoggedIn ? 'home' : 'home';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<CreateServiceProvider>(
          create: (_) => CreateServiceProvider(),
        ),
        ChangeNotifierProvider<DetailsPageProvider>(
          create: (_) => DetailsPageProvider(),
        ),
        ChangeNotifierProvider<MyAdvertsProvider>(
          create: (_) => MyAdvertsProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (_) => AdminProvider(),
        )
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  final String
      initialRoute; // Add this line to declare the initialRoute parameter

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: initialRoute, // Use the provided initialRoute
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      themeMode: context.watch<ThemeProvider>().currentTheme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {
        'phone': (context) => const MyPhone(),
        'home': (context) => const HomePage(),
        'verify': (context) => const MyVerify(),
        'profile': (context) => const ProfileScreen(),
        'update': (context) => const UpdateProfileScreen(),
        'myAdverts': (context) => const MyAdverts(),
        'updateAdvert': (context) => const UpdateServicePage(),
        'createService': (context) => const CreateServicePage(),
        'bookmark': (context) => const BookmarkPage(),
        'onBoarding': (context) => const OnboardingScreen(),
        'users': (context) => const UsersPage(),
        'review': (context) => const ReviewService(),
        'pending': (context) => const PendingServices()
      },
    );
  }

}
