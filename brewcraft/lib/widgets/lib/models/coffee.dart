import 'package:flutter/material.dart';

enum CoffeeCategory { espresso, milkBased, cold, specialty }

extension CoffeeCategoryLabel on CoffeeCategory {
  String get label {
    switch (this) {
      case CoffeeCategory.espresso:
        return 'Espresso';
      case CoffeeCategory.milkBased:
        return 'Milk Based';
      case CoffeeCategory.cold:
        return 'Cold Brew';
      case CoffeeCategory.specialty:
        return 'Specialty';
    }
  }
}

class Coffee {
  final String id;
  final String name;
  final String origin;
  final String description;
  final double price;
  final double rating;
  final CoffeeCategory category;
  final Color primaryColor;
  final Color secondaryColor;
  final double intensity; // 0..1, drives crema thickness in the painter
  final int prepSeconds; // used by the brewing / order tracking animation

  const Coffee({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.price,
    required this.rating,
    required this.category,
    required this.primaryColor,
    required this.secondaryColor,
    required this.intensity,
    this.prepSeconds = 180,
  });
}
