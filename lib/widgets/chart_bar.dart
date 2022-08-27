import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  late final String Label;
  late final double spendingAmount;
  late final double spendPcntTotal;
  ChartBar({required this.Label,required this.spendingAmount,required this.spendPcntTotal});


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (ctx,constraints){
      return Column(
        children: [
          Container(
            height: constraints.maxHeight*0.15,
            child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}')),
          ),
          Container(
              height: constraints.maxHeight*0.6,
              width: 10,
              child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 1.0,),
                        color: const Color.fromRGBO(220, 220,220, 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight*0.05,
                    ),
                    FractionallySizedBox(heightFactor: spendPcntTotal,
                        child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            )))])),
          SizedBox (height: constraints.maxHeight*0.05),
          Container(
              height: constraints.maxHeight*0.15,
              child: Text(Label)),
        ],
      );
    }) ;


  }
}
