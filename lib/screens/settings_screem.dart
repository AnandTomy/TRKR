import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/customer_controller.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  CustomerController customerController = Get.find<CustomerController>();
  TextEditingController _rateController = TextEditingController();

  @override
  void initState() {
    customerController.getRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Milk Rate:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rate per liter',
                    hintText: 'Enter rate',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    customerController.setRate(_rateController.text);
                    customerController.getRate();
                  },
                  child: Text('Save'),
                ),
                SizedBox(height: 16.0),
                Obx(
                  () => Text(
                    'Current Milk Rate: ${customerController.milkRate.value}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<CustomerController>(
            builder: (controller) {
              return Visibility(
                  visible: controller.isLoading,
                  child: Scaffold(body: Center(child: CircularProgressIndicator())));
            },
          )
        ],
      ),
    );
  }
}
