import 'package:iamj/data/datasources/local_data_source.dart';
import 'package:iamj/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final LocalDataSource localDataSource;
  OnboardingRepositoryImpl(this.localDataSource);

  @override
  bool isFirstLaunch() => localDataSource.getIsFirstLaunch();

  @override
  Future<void> saveUserPurpose(String purpose) => localDataSource.savePurpose(purpose);

  @override
  Future<int> getLatestStep() async {
    return 0;
  }

  @override
  Future<void> saveProgress(int step) {
    // TODO: implement saveProgress
    throw UnimplementedError();
  }
}
