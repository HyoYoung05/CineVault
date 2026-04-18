import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Injects the controller so the view can use it
    Get.lazyPut<HomeController>(() => HomeController());
  }
}