import 'package:get/get.dart';
import '../controllers/lock_controller.dart';

class LockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockController>(() => LockController());
  }
}
