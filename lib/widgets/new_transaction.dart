import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  late final Function Utrx;

  NewTransaction(
    this.Utrx,
  );

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _tittleControler = TextEditingController();

  final _amountControler = TextEditingController();

  DateTime? _SavedDate;

  void onSubmit() {
    if (_amountControler == null) {
      return;
    }
    final title = _tittleControler.text;
    final amount = double.parse(_amountControler.text);
    if (title.isEmpty || amount.isNegative || _SavedDate == null) {
      return;
    }
    widget.Utrx(title, amount, _SavedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 5),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _SavedDate = pickedDate;
      });
    });
    print('....');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.only(
                top: 10,
                right: 10,
                left: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              TextField(
                controller: _tittleControler,
                onSubmitted: (_) => onSubmit(),
                decoration: const InputDecoration(labelText: 'Tittle'),
              ),
              TextField(
                controller: _amountControler,
                onSubmitted: (_) => onSubmit(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text(_SavedDate == null
                          ? 'No date Choose'
                          : 'Picked Date: ${DateFormat.yMd().format(_SavedDate!)}')),
                  InkWell(
                    onTap: () {
                      _presentDatePicker();
                    },
                    child: const Text(
                      "Select Date ",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                  onPressed: onSubmit,
                  color: Theme.of(context).primaryColor,
                  child: const Text('Add Transaction',
                      style: TextStyle(color: Colors.white))),
            ])),
      ),
    );
  }
}
