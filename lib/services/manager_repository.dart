import 'package:brabrabra_manager/models/manager.dart';
import 'package:brabrabra_manager/services/manager_api_provider.dart';

class ManagerRepository {
  final _managerProvider = ManagerProvider();
  Future<Manager> getManagerByKey(String key) {
    return _managerProvider.getManagerByKey(key);
  }
}
