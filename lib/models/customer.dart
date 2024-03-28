import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../controllers/customer_controller.dart';

class Customer {
  String name;
  String address;
  String phoneNumber;
  double milkAmount;
  String id;
  Timestamp fromDate;
  int due ;
  double totalAmount;
  DateTime today = DateTime.now();
  CustomerController customerController = Get.find<CustomerController>();
  Customer(
      {this.id = '',
        this.due = 0,
        this.totalAmount = 0,
      required this.name,
      required this.fromDate,
      required this.address,
      required this.phoneNumber,
      required this.milkAmount}) {
    print('findamountcalled');
    findAmount();
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'milkAmount': milkAmount,
      'date': fromDate,
    };
  }

  void findAmount(){

    int toToday = today.difference(fromDate.toDate()).inDays;
    totalAmount = (toToday*customerController.milkRate.value*milkAmount)+due;
    print('today $today rate ${customerController.milkRate.value}   amount $milkAmount');


  }

}
