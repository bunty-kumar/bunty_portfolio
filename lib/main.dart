import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/portfolio_provider.dart';
import 'providers/auth_provider.dart';
import 'views/portfolio/portfolio_view.dart';
import 'views/admin/admin_view.dart';

void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const DynamicPortfolioApp(),
    ),
  );
}

class DynamicPortfolioApp extends StatefulWidget {
  const DynamicPortfolioApp({super.key});

  @override
  State<DynamicPortfolioApp> createState() => _DynamicPortfolioAppState();
}

class _DynamicPortfolioAppState extends State<DynamicPortfolioApp> {
  bool _isAdminMode = false;

  @override
  void initState() {
    super.initState();
    final Uri uri = Uri.base;
    if (uri.path.contains('/admin') || uri.fragment.contains('/admin')) {
      _isAdminMode = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final themeConfig = provider.theme;
    final branding = provider.branding;

    return MaterialApp(
      title: branding.siteTitle.isNotEmpty ? branding.siteTitle : 'Dynamic Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: themeConfig.isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: themeConfig.bgColor,
        primaryColor: themeConfig.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeConfig.primaryColor,
          brightness: themeConfig.isDarkMode ? Brightness.dark : Brightness.light,
          primary: themeConfig.primaryColor,
          secondary: themeConfig.secondaryColor,
          surface: themeConfig.surfaceColor,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: themeConfig.isDarkMode ? Brightness.dark : Brightness.light).textTheme,
        ),
        useMaterial3: true,
      ),
      home: _isAdminMode ? const AdminView() : const PortfolioView(),
      onGenerateRoute: (settings) {
        if (settings.name == '/admin') {
          return MaterialPageRoute(
            builder: (_) => const AdminView(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const PortfolioView(),
        );
      },
    );
  }
}
