import 'package:flutter/material.dart';

class Transaction{
  late final String id;
  late final String tittle;
  late double amount;
  late DateTime date;

  Transaction({
    required this.id,
    required this.tittle,
    required this.amount,
    required this.date,
  });

}