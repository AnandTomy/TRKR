import 'package:anand_test/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  bool isLoading = false;
  Rx<double> milkRate = 0.0.obs;
  Rx<double> due = 0.0.obs;
  RxList<Customer> customerList = <Customer>[].obs;
   DateTime? customerDate;
  var db = FirebaseFirestore.instance;

  Future<void> getRate() async {
    await db.collection("masters").doc('data').get().then((value) => milkRate.value = value['price']);
    print("rate found ${milkRate.value}");
  }
  Future<void> getDue(String id) async {
    await db.collection("users").doc(id).get().then((value) => due.value =  value['due'].toDouble());
    await db.collection("users").doc(id).get().then((value) => customerDate = value['fromDate'].toDate());
    print('dueFromFire controller $due');
    print(milkRate.value);
  }

  void setRate(String rate) async {
    isLoading = true;
    update();
    // await Future.delayed(Duration(seconds: 1));

    final data = <String, dynamic>{
      "price": double.tryParse(rate)!,
    };

    milkRate.value = double.tryParse(rate)!;

    try {
      await db.collection("masters").doc('data').update(data).then((value) {});
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading = false;
    update();
  }

  void setDue(String id, double due,DateTime date)async{

    isLoading = true;
    update();
    // await Future.delayed(Duration(seconds: 1));

    final data = <String, dynamic>{
      "due": due,
      "fromDate":Timestamp.fromDate(date),
    };


    try {
      await db.collection("users").doc(id).update(data).then((value) {});
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading = false;
    update();

  }
}
