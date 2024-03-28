
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.name, required this.amount, required this.onPress, required this.date, required this.totalAmount});
  final VoidCallback onPress;
  final String name;
  final double amount;
  final double totalAmount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 150,
        child: Card(
          color: Colors.white10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text(name), Text(amount.toString()),Text(date)],
                ),
              ),
              Expanded(
                flex: 1,
                  child: Center(
                    child: Text(totalAmount.toString()),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
