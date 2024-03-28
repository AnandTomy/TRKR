import 'package:anand_test/controllers/customer_controller.dart';
import 'package:anand_test/models/customer.dart';
import 'package:anand_test/screens/settings_screem.dart';
import 'package:anand_test/screens/user_details_screeen.dart';
import 'package:anand_test/widgets/list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'add_customer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomerController customerController = Get.find<CustomerController>();
  int pagenum = 0;
  var db = FirebaseFirestore.instance;

  @override
  void initState() {

    onInit();
    super.initState();


  }
  String toDayFormat(DateTime date){
    return '${date.day}-${date.month}-${date.year}';
  }

  void onInit() async{
    await customerController.getRate();
    await readFromFirebase();
  }


  Future<void> readFromFirebase() async {
    customerController.customerList.clear();
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        customerController.customerList.add(
          Customer(
            id: doc.id,
            name: doc['name'],
            address: doc['name'],
            phoneNumber: doc['phoneNumber'],
            milkAmount: doc['milkAmount'],
            fromDate: doc['fromDate'],
            due: doc['due'].toInt()
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRKR'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(SettingsScreen());
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: pagenum == 0
          ? Obx(
              () => ListView.builder(
                itemCount: customerController.customerList.length,
                itemBuilder: (context, index) {
                  return ListCard(
                    onPress: () {
                      Get.to(UserDetailsScreen(
                        customerdetails: customerController.customerList[index],
                      ));
                    },
                    name: customerController.customerList[index].name,
                    amount: customerController.customerList[index].milkAmount,
                    date: toDayFormat(customerController.customerList[index].fromDate.toDate()),
                    totalAmount: customerController.customerList[index].totalAmount,
                  );
                },
              ),
            )
          : CustomerForm(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          readFromFirebase();
          setState(() {
            pagenum = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'add')
        ],
      ),
    );
  }
}
