import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {
      'name': 'Gas Filling',
      'icon': FontAwesomeIcons.gasPump,
    },
    {
      'name': 'Grocery',
      // ignore: deprecated_member_use
      'icon': FontAwesomeIcons.shoppingCart,
    },
    {
      'name': 'Milk',
      'icon': FontAwesomeIcons.mugHot,
    },
    {
      'name': 'Internet',
      'icon': FontAwesomeIcons.wifi,
    },
    {
      'name': 'Gaming',
      'icon': FontAwesomeIcons.gamepad,
    },
    {
      'name': 'Book',
      'icon': FontAwesomeIcons.book,
    },
    {
      'name': 'Food',
      'icon': FontAwesomeIcons.bowlFood,
    },
    {
      'name': 'Drink',
      'icon': FontAwesomeIcons.glassWater,
    },
    {
      'name': 'Home',
      'icon': FontAwesomeIcons.home,
    },
    {
      'name': 'Education',
      'icon': FontAwesomeIcons.graduationCap,
    },
    {
      'name': 'Others',
      'icon': FontAwesomeIcons.cartPlus,
    },
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
      (category) => category['name'] == categoryName,
      orElse: () => {'icon': FontAwesomeIcons.shoppingCart},
    );
    return category['icon'];
  }
}
