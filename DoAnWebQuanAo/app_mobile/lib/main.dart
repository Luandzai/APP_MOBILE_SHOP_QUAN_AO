import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/voucher_provider.dart';
import 'providers/order_provider.dart';

/// Entry point của ứng dụng Blank Canvas
/// 
/// Khởi tạo app với các providers cần thiết.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Product Provider
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        
        // Cart Provider
        ChangeNotifierProvider(create: (_) => CartProvider()),
        
        // Wishlist Provider
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        
        // Voucher Provider
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        
        // Order Provider
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const BlankCanvasApp(),
    ),
  );
}

