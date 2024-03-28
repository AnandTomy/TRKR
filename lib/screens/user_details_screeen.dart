import 'package:anand_test/controllers/customer_controller.dart';
import 'package:anand_test/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({required this.customerdetails, super.key});
  final Customer customerdetails;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  CustomerController customerController = Get.find<CustomerController>();
  final TextEditingController _dateController=TextEditingController();
  final TextEditingController _givenAmountController=TextEditingController();
  // late DateTime customerDate; = widget.customerdetails.fromDate.toDate();
  late double milkAmount = widget.customerdetails.milkAmount;
  late double rate = customerController.milkRate.value;
  double amount = 0;
   double totalamount = 0;
   int due = 0;
  DateTime _selectedDate = DateTime.now();
  DateTime today = DateTime.now();

  var db = FirebaseFirestore.instance;
  @override
  void initState() {


onInit();
    super.initState();
  }
void onInit()async{
    await customerController.getDue(widget.customerdetails.id);
    due =  customerController.due.value.toInt();
    print('dueFromFire  $due');
  _dateController.text = toDayFormat(DateTime.now());
  customerController.getRate();
  findAmount();
}


  void findAmount(){
    int differenceInDays = _selectedDate.difference(customerController.customerDate!).inDays;
    int toToday = today.difference(customerController.customerDate!).inDays;
    totalamount = (toToday*rate*milkAmount)+due;

    setState(() {
      amount = (differenceInDays*rate*milkAmount)+due;
      print('differenceInDays $differenceInDays rate $rate   amount $amount');
    });


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
        findAmount();
      });
  }
  String toDayFormat(DateTime date){

    return '${date.day}-${date.month}-${date.year}';

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        actions: [
          IconButton(
              onPressed: () {
                db.collection("users").doc(widget.customerdetails.id).delete().then(
                  (doc) {
                    customerController.customerList
                        .removeWhere((element) => element.id == widget.customerdetails.id);
                    print("Document deleted");
                    Get.back();
                  },
                  onError: (e) => print("Error updating document $e"),
                );

              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children:[Text('Name: ${widget.customerdetails.name}'),
                Text('ID: ${widget.customerdetails.id}'),
                SizedBox(height: 16.0),
                Text('Payment Status:'),]),
                Expanded(
                  child: Center(
                    child: Text(
                      "${widget.customerdetails.milkAmount.toString()} L ",style: TextStyle(
                      fontSize: 30
                    ),),
                  ),
                )
              ],
            ),
            Switch(value: false, onChanged: (value) {}),
            SizedBox(height: 16.0),
            Text('Amount to be Paid: $totalamount'),

            SizedBox(height: 16.0),
            TextFormField(
              readOnly: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                floatingLabelBehavior:FloatingLabelBehavior.always ,
                labelText: 'From Date',
                hintText: toDayFormat(customerController.customerDate??DateTime.now())

              ),
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
            Text('Amount to be payed for ${toDayFormat(_selectedDate)}  is $amount'),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount Given'),
              controller:_givenAmountController ,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Notes'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                due = amount.toInt() - int.tryParse(_givenAmountController.text)! ;
                print('due $due');
                customerController.setDue(widget.customerdetails.id, due.toDouble(),_selectedDate);
                onInit();
                int index = customerController.customerList.indexWhere((customer) => customer.id == widget.customerdetails.id);
                customerController.customerList[index].totalAmount = totalamount;

                setState(() {

                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
