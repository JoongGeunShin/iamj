import 'package:iamj/domain/repositories/lock_repository.dart';

class LockRepositoryImpl implements LockRepository{
  bool _isLocked = false;
  @override
  bool getLockState() {
    return _isLocked;
  }

  @override
  void setLockState(bool value) {
    _isLocked = value;
  }
}