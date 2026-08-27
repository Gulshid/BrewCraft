import 'package:flutter/material.dart';
import '../models/coffee.dart';

final List<Coffee> coffeeMenu = [
  const Coffee(
    id: 'espresso',
    name: 'Classic Espresso',
    origin: 'Ethiopia · Yirgacheffe',
    description:
        'A tight, syrupy shot with notes of dark chocolate and stone fruit. Pulled at 9 bars for a thick golden crema.',
    price: 3.20,
    rating: 4.8,
    category: CoffeeCategory.espresso,
    primaryColor: Color(0xFF6F4E37),
    secondaryColor: Color(0xFF3E2723),
    intensity: 0.95,
    prepSeconds: 45,
  ),
  const Coffee(
    id: 'flatwhite',
    name: 'Flat White',
    origin: 'Colombia · Huila',
    description:
        'Double ristretto with velvety microfoam, poured to a silky, glossy finish. Balanced sweetness, low bitterness.',
    price: 4.50,
    rating: 4.9,
    category: CoffeeCategory.milkBased,
    primaryColor: Color(0xFFD7B899),
    secondaryColor: Color(0xFF8B5E3C),
    intensity: 0.6,
    prepSeconds: 90,
  ),
  const Coffee(
    id: 'latte',
    name: 'Vanilla Latte',
    origin: 'Brazil · Cerrado',
    description:
        'Steamed milk folded into a smooth espresso base with real vanilla bean. Finished with a light dusting of cinnamon.',
    price: 4.80,
    rating: 4.7,
    category: CoffeeCategory.milkBased,
    primaryColor: Color(0xFFE8CBA3),
    secondaryColor: Color(0xFFB6742A),
    intensity: 0.45,
    prepSeconds: 100,
  ),
  const Coffee(
    id: 'coldbrew',
    name: 'Nitro Cold Brew',
    origin: 'Guatemala · Antigua',
    description:
        'Steeped for eighteen hours, charged with nitrogen for a cascading, stout-like head and a naturally sweet body.',
    price: 5.20,
    rating: 4.6,
    category: CoffeeCategory.cold,
    primaryColor: Color(0xFF4A3222),
    secondaryColor: Color(0xFF1F140D),
    intensity: 0.7,
    prepSeconds: 30,
  ),
  const Coffee(
    id: 'mocha',
    name: 'Dark Mocha',
    origin: 'Sumatra · Mandheling',
    description:
        'Rich espresso meets 70% dark chocolate and steamed milk, topped with whipped cream and a cocoa dusting.',
    price: 5.00,
    rating: 4.9,
    category: CoffeeCategory.specialty,
    primaryColor: Color(0xFF8B5E3C),
    secondaryColor: Color(0xFF3E2723),
    intensity: 0.8,
    prepSeconds: 120,
  ),
  const Coffee(
    id: 'macchiato',
    name: 'Caramel Macchiato',
    origin: 'Kenya · Nyeri',
    description:
        'Vanilla-marked steamed milk topped with a shot of espresso and a lattice of hand-poured caramel.',
    price: 4.90,
    rating: 4.7,
    category: CoffeeCategory.specialty,
    primaryColor: Color(0xFFC9873A),
    secondaryColor: Color(0xFF6F4E37),
    intensity: 0.55,
    prepSeconds: 110,
  ),
];
