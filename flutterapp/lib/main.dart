import 'package:flutter/material.dart';
import 'package:flutterapp/pages/landing_page.dart';
import 'package:flutterapp/providers/theme_provider.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/services/graphQL/graphQL_service.dart';
import 'package:flutterapp/utils/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationBase>(
          create: (BuildContext context) => AuthenticationFirebase(),
        ),
        Provider<DataService>(
          create: (BuildContext context) => GraphQLService(),
        ),
        ChangeNotifierProvider<ThemeChanger>(
          create: (BuildContext context) => ThemeChanger(ThemeData.dark()),
        ),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'CR'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      title: 'Flutter Demo',
      home: LandingPage(),
      theme: theme.getTheme(),
    );
  }
}
