import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hunger_hub/core/di/injection.dart';
import 'package:hunger_hub/core/router/app_router.dart';
import 'package:hunger_hub/core/theme/app_theme.dart';
import 'config/app_config.dart';
import 'features/cart/cart_cubit.dart';
import 'firebase/notification/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ── Environment ──
  AppConfig.setEnvironment(AppEnvironment.dev);
  // ── Firebase Init ──
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ── Notifications Init ──
  await NotificationService.instance.init();
  // ── Dependencies Init ──
  await configureDependencies();

  runApp(const HungryHubApp());
}

class HungryHubApp extends StatelessWidget {
  const HungryHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartCubit>(),
      child: MaterialApp.router(
        title: 'HungryHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
