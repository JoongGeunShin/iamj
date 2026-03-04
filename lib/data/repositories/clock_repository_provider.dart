import 'package:iamj/domain/repositories/clock_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'clock_repository_impl.dart';

part 'clock_repository_provider.g.dart';

@riverpod
ClockRepository clockRepository(Ref ref) {
  return ClockRepositoryImpl();
}


@riverpod
Stream<DateTime> watchTime(Ref ref) {
  final repository = ref.watch(clockRepositoryProvider);
  return repository.watchTime();
}