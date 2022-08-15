import 'package:flutter/material.dart';

class ItemModel {
  bool expanded;
  String headerItem;
  List<String> discription;
  Color colorsItem;

  ItemModel({
    this.expanded: false,
    required this.headerItem,
    required this.discription,
    required this.colorsItem,
  });
}