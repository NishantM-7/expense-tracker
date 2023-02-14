import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    if (amountController.text == null) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime
                .now()) //  then() code is executed when Future resolves to a value
        .then((pickedDate) {
      // Future waits for the user to pick a date.... once picked Future is triggered and to get informed about it we use then()
      if (pickedDate == null) {
        return;
      }
      // ignore: dead_code
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                autofocus: true,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   inputTitle = val;

                // }
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   inputAmount = val;

                // }
              ),
              Container(
                margin: EdgeInsets.all(6),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}'),
                    ),
                    TextButton(
                        onPressed: _presentDatePicker,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: submitData,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  primary: Color.fromARGB(229, 6, 79, 143),
                  //backgroundColor: Color.fromARGB(255, 147, 236, 193),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
