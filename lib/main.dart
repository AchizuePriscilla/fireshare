import 'package:fireshare/handlers/navigation_handler.dart';
import 'package:fireshare/pages/create_account.dart';
import 'package:fireshare/utils/locator.dart';
import 'package:fireshare/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:fireshare/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'FireShare',
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationHandler>().navigatorKey,
        theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.teal,
                backgroundColor: Colors.black)
            .copyWith(),
        home: Home(),
        routes: {
          Home.id: (context) => Home(),
          CreateAccount.id: (context) => CreateAccount(),
        },
      ),
    );
  }
}
