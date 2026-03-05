import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/domain/entities/lock_state.dart';
import 'package:iamj/data/repositories/lock_repository_impl.dart';
import 'package:iamj/domain/repositories/lock_repository.dart';

import '../../domain/usecase/lock_use_case.dart';

part 'lock_repository_provider.g.dart';

@riverpod
LockRepository lockRepository(Ref ref) {
  return LockRepositoryImpl();
}
@riverpod
LockUseCase lockUseCase(Ref ref) {
  final repository = ref.watch(lockRepositoryProvider);
  return LockUseCase(repository);
}
@riverpod
class LockStateNotifier extends _$LockStateNotifier {
  @override
  LockState build() {
    final repository = ref.watch(lockRepositoryProvider);
    return LockState(repository.getLockState());
  }

  void lock() {
    ref.read(lockRepositoryProvider).setLockState(true);
    state = LockState(true);
  }

  void unlock() {
    ref.read(lockRepositoryProvider).setLockState(false);
    state = LockState(false);
  }
}