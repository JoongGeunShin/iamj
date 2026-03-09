import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/presentation/home/screens/home_screen.dart';
import 'package:iamj/presentation/onboarding/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/local_data_source.dart';
import 'data/repositories/onboarding_repository_impl.dart';
import 'data/repositories/onboarding_repository_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(
          OnboardingRepositoryImpl(LocalDataSource(prefs)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPurpose = ref.watch(savedUserPurposeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: savedPurpose.when(
        data: (purpose) {
          if (purpose != null && purpose.isNotEmpty) {
            return const HomeScreen();
          } else {
            return const OnboardingScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => const OnboardingScreen(),
      ),
    );
  }
}

