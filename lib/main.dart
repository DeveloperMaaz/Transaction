import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transaction/widgets/chart.dart';
import 'package:transaction/widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/transactionlist.dart';
import 'package:flutter/services.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        errorColor: Colors.red,
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: inmain(),
    );
  }
}

class inmain extends StatefulWidget {
  const inmain({Key? key}) : super(key: key);

  @override
  _inmainState createState() => _inmainState();
}

class _inmainState extends State<inmain> with WidgetsBindingObserver {
  @override
  initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  final List<Transaction> transaction = [
    // Transaction(
    //   id: 't1',
    //   tittle: 'Shows',
    //   amount: 29.9,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return transaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _userNewTransaction(
      String trxTitle, double trxAmount, DateTime dateUpdate) {
    final trx = Transaction(
        id: DateTime.now().toString(),
        tittle: trxTitle,
        amount: trxAmount,
        date: dateUpdate);

    setState(() {
      transaction.add(trx);
    });
  }

  void _addTransactionSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_userNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  bool _showResult = false;

  void _deleteData(String id) {
    setState(() {
      transaction.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandScapeContent(
      MediaQueryData MediaQuery, AppBar appbar, Widget txList) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Select"),
        Switch.adaptive(
            value: _showResult,
            onChanged: (val) {
              setState(() {
                _showResult = val;
              });
            }),
      ]),
      _showResult
          ? Container(
              height: (MediaQuery.size.height -
                      appbar.preferredSize.height -
                      MediaQuery.padding.top) *
                  1,
              child: Chart(_recentTransaction))
          : txList,
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData MediaQuery, AppBar appbar, Widget txList) {
    return [
      Container(
          height: (MediaQuery.size.height -
                  appbar.preferredSize.height -
                  MediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransaction)),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLand = MediaQuery.of(context).orientation == Orientation.landscape;
    final dynamic appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(" Personal Expense "),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _addTransactionSheet(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _addTransactionSheet(context),
              ),
            ],
          );
    final txList = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,

        child: TransactionList(transaction, _deleteData));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLand) ..._buildLandScapeContent(mediaQuery, appbar, txList),
            if (!isLand) ..._buildPotraitContent(mediaQuery, appbar, txList)
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appbar,
          )
        : Scaffold(
            appBar: appbar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _addTransactionSheet(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
