import '../repositories/lock_repository.dart';

class LockUseCase {
  final LockRepository _repository;

  LockUseCase(this._repository);

  bool getLockState() => _repository.getLockState();

  void lock() => _repository.setLockState(true);

  void unlock() => _repository.setLockState(false);
}