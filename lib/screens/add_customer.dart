import 'package:anand_test/controllers/customer_controller.dart';
import 'package:anand_test/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  CustomerController customerController = Get.find<CustomerController>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _milkAmountController;
  late TextEditingController _dateController;
  var db = FirebaseFirestore.instance;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {

    // final user = <String, dynamic>{
    //   "first": "Ada",
    //   "last": "Lovelace",
    //   "born": 1815
    // };
    // db.collection("users").add(user).then((DocumentReference doc) =>
    //     print('DocumentSnapshot added with ID: ${doc.id}'));

    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _milkAmountController = TextEditingController();
    _dateController = TextEditingController();
    _dateController.text=toDayFormat(_selectedDate);
  }

  String toDayFormat(DateTime date){

    return '${date.day}-${date.month}-${date.year}';

  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _milkAmountController.dispose();
    _dateController.dispose();
    super.dispose();
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text=toDayFormat(_selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _milkAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount of Milk',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount of milk';
                  }
                  return null;
                },
              ),
              TextFormField(
                onTap: (){
                  _selectDate(context);
                },

                controller: _dateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the data
                    Customer customer = Customer(
                      name: _nameController.text,
                      address: _addressController.text,
                      phoneNumber: _phoneController.text,
                      milkAmount: double.parse(_milkAmountController.text),
                      fromDate: Timestamp.fromDate(_selectedDate)
                    );

                    Map<String, dynamic> user =customer.toMap();
                    user.addAll(
                        {
                          'fromDate':Timestamp.fromDate(_selectedDate),
                          'due':0

                        });
                    db.collection("users").add(user).then((DocumentReference doc) =>
                        print('DocumentSnapshot added with ID: ${doc.id}'));

                    _formKey.currentState!.reset();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      );
  }
}