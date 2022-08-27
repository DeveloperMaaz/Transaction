import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction/models/transaction.dart';

class TransactionList extends StatefulWidget {
  late final List<Transaction> _transactionz;
  late final Function Del;

  TransactionList(this._transactionz, this.Del);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late Color _bgColor;

  @override
  void initState() {
    const activeColor = [
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.black54,
    ];
    _bgColor = activeColor[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: widget._transactionz.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "No Transaction Yet.!",
                  style: TextStyle(
                    fontSize: 26.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: widget._transactionz.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _bgColor,
                      radius: 30.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\$${widget._transactionz[index].amount}'),
                      ),
                    ),
                    title: Text(
                      widget._transactionz[index].tittle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .format(widget._transactionz[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? FlatButton.icon(
                            onPressed: () =>
                                widget.Del(widget._transactionz[index].id),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            textColor: Theme.of(context).errorColor,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () =>
                                widget.Del(widget._transactionz[index].id),
                          ),
                  ),
                );
              }),
    );
  }
}
