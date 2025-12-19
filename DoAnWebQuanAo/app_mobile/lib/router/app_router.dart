import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/main_screen.dart'; // Import MainScreen
import '../screens/home/home_screen.dart';
import '../screens/product/product_list_screen.dart';
import '../screens/product/product_detail_screen.dart' as product_detail;
import '../screens/cart/cart_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/voucher/vouchers_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/payment_result_screen.dart';
import '../screens/order/orders_screen.dart';
import '../screens/order/order_detail_screen.dart';
import '../screens/return/returns_screen.dart';
import '../screens/return/return_request_screen.dart';
import '../screens/product/product_reviews_screen.dart';
import '../models/product.dart';

/// App Router configuration sử dụng GoRouter
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,

    routes: [
      // Splash
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      // Main Shell (Bottom Navigation)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                name: 'home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 2: Products
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.products,
                name: 'products',
                builder: (context, state) {
                  return ProductListScreen(
                    category: state.uri.queryParameters['category'],
                    search: state.uri.queryParameters['search'],
                    sort: state.uri.queryParameters['sort'],
                  );
                },
              ),
            ],
          ),

          // Branch 3: Cart
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.cart,
                name: 'cart',
                builder: (_, __) => const CartScreen(),
              ),
            ],
          ),

          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                name: 'profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Các routes khác (không nằm trong Shell hoặc push đè lên Shell)

      // Product Detail (Push đè lên Shell)
      GoRoute(
        path: '${Routes.products}/:slug',
        name: 'product-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => product_detail.ProductDetailScreen(
          slug: state.pathParameters['slug']!,
        ),
      ),

      // Checkout
      GoRoute(
        path: Routes.checkout,
        name: 'checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const CheckoutScreen(),
      ),
      GoRoute(
        path: Routes.paymentResult,
        name: 'payment-result',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final success = state.uri.queryParameters['success'] == 'true';
          final orderId = int.tryParse(
            state.uri.queryParameters['orderId'] ?? '',
          );
          final message = state.uri.queryParameters['message'];
          return PaymentResultScreen(
            isSuccess: success,
            orderId: orderId,
            message: message,
          );
        },
      ),

      // Orders
      GoRoute(
        path: Routes.orders,
        name: 'orders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const OrdersScreen(),
      ),
      GoRoute(
        path: '${Routes.orders}/:id',
        name: 'order-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            OrderDetailScreen(orderId: int.parse(state.pathParameters['id']!)),
      ),

      // Returns
      GoRoute(
        path: Routes.returns,
        name: 'returns',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const ReturnsScreen(),
      ),
      GoRoute(
        path: '${Routes.returnRequest}/:orderId',
        name: 'return-request',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ReturnRequestScreen(
          orderId: int.parse(state.pathParameters['orderId']!),
        ),
      ),

      // Other
      GoRoute(
        path: Routes.search,
        name: 'search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const SearchScreen(),
        routes: [
          GoRoute(
            path: 'results',
            name: 'search-results',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => ProductListScreen(
              category: state.uri.queryParameters['category'],
              search: state.uri.queryParameters['search'],
              sort: state.uri.queryParameters['sort'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.wishlist,
        name: 'wishlist',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const WishlistScreen(),
      ),
      GoRoute(
        path: Routes.vouchers,
        name: 'vouchers',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const VouchersScreen(),
      ),
      GoRoute(
        path: Routes.editProfile,
        name: 'edit-profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.productReviews,
        name: 'product-reviews',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ProductReviewsScreen(
            reviews: extras['reviews'] as List<ProductReview>,
            avgRating: extras['avgRating'] as double?,
          );
        },
        parentNavigatorKey: _rootNavigatorKey,
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Trang không tồn tại',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Route paths
class Routes {
  Routes._();

  // Splash & Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main
  static const String home = '/home';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String search = '/search';
  static const String profile = '/profile';

  // Checkout
  static const String checkout = '/checkout';
  static const String paymentResult = '/payment-result';

  // Orders
  static const String orders = '/orders';

  // Profile sub-routes
  static const String editProfile = '/profile/edit';
  static const String wishlist = '/wishlist';
  static const String vouchers = '/vouchers';
  static const String returns = '/returns';
  static const String returnRequest = '/return-request';
  static const String productReviews = '/product-reviews';
}
