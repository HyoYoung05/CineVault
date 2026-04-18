import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Injects the search logic only when needed [cite: 25]
    Get.lazyPut<SearchModuleController>(() => SearchModuleController());
  }
}