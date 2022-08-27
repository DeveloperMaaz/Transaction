import 'package:flutter/material.dart';
import 'package:transaction/models/transaction.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';
class Chart extends StatelessWidget {
  late final List<Transaction> RecentTransaction;
  Chart(this.RecentTransaction);

  List<Map<String,dynamic>> get groupedTransaction{
    return List.generate(7, (index) {

      final weekDay=DateTime.now().subtract(Duration(days: index));

      double TotalAmount=0.0;

      for(var i=0;i<RecentTransaction.length;i++){
        if(RecentTransaction[i].date.day==weekDay.day &&
            RecentTransaction[i].date.month==weekDay.month &&
            RecentTransaction[i].date.year==weekDay.year){
          TotalAmount+=RecentTransaction[i].amount;
        }
      }
      return {'day':DateFormat.E().format(weekDay).substring(0,1),
        'amount':TotalAmount};
    }).reversed.toList();
  }

  double get maxTotal{
    return groupedTransaction.fold(0.0, (sum, item) {
      return  sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransaction.map((data){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(Label: data['day'],
                  spendingAmount: data['amount'],
                  spendPcntTotal: maxTotal==0.0?0.0:(data['amount']as double)/maxTotal
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
