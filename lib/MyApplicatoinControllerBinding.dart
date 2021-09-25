import 'package:get/get.dart';
import 'controller/Controller.dart';
class MyAppControllerBinding implements Bindings {
  @override
  void dependencies(){
    Get.lazyPut<Controller>(() => Controller());
  }
}