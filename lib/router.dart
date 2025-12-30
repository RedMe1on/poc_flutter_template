import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poc_flutter_template/pages/product_detail.dart';
import 'package:poc_flutter_template/pages/products.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text('Error: ${state.error}')),
  ),
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/products'),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'product_detail',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ProductDetailScreen(productId: id);
          },
        ),
      ],
    ),
  ],
);
