import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20)),
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          accentColor: Colors.amberAccent

          // colorScheme: ColorScheme(
          //     brightness: Brightness.light,
          //     primary: Colors.amber,
          //     onPrimary: Colors.black,
          //     secondary: Colors.cyan,
          //     onSecondary: Colors.white,
          //     error: Colors.red,
          //     onError: Colors.redAccent,
          //     background: Colors.black,
          //     onBackground: Colors.yellow,
          //     surface: Colors.yellow,
          //     onSurface: Colors.orange)
          ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 'T1',
    //   title: 'Shoes',
    //   amount: 600,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'T2',
    //   title: 'Groceries',
    //   amount: 450,
    //   date: DateTime.now(),
    // ),
  ];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final txNew = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(txNew);
    });
  }

  void startAddNewTransaction() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        isScrollControlled: true,
        builder: (context) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Tracker'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () {
                    startAddNewTransaction();
                  },
                ),
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            // ignore: prefer_const_constructors
            title: Text('Expense Tracker'),
            actions: [
              IconButton(
                  onPressed: startAddNewTransaction, icon: Icon(Icons.add)),
            ],
          );
    final isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // ignore: sized_box_for_whitespace
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show Chart',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandscape)
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape)
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(
                _userTransactions,
                _deleteTransaction,
              ),
            ),
          if (isLandscape)
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: TransactionList(
                      _userTransactions,
                      _deleteTransaction,
                    ),
                  ),

          // ignore: prefer_const_constructors
        ]),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      startAddNewTransaction();
                    },
                  ),
          );
  }
}





/*Container(
                    child: TextButton(
                        onPressed: () {}, child: Icon(Icons.delete_rounded)),
                    margin:
                        EdgeInsets.only(left: 80, right: 5, bottom: 5, top: 5),
                    // padding: EdgeInsets.all(20),
                  ) 
                  */
