import 'package:iamj/domain/repositories/clock_repository.dart';

class ClockRepositoryImpl implements ClockRepository {
  @override
  Stream<DateTime> watchTime() =>
      Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
}

