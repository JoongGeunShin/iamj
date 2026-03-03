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
        // 데이터 로드가 완료되었을 때
        data: (purpose) {
          if (purpose != null && purpose.isNotEmpty) {
            return const HomeScreen(); // 데이터 있으면 홈
          } else {
            return const OnboardingScreen(); // 없으면 온보딩
          }
        },
        // 앱이 처음 켜질 때 SharedPreferences 읽는 동안 보여줄 화면
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        // 에러 발생 시 (일단 온보딩으로 보냄)
        error: (err, stack) => const OnboardingScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
