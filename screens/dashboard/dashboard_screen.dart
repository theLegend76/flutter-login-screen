// // import 'package:flutter/material.dart';
// // import '../category/category_screen.dart';
// // import '../subcategory/subcategory_screen.dart';
// // import '../brands/brands_screen.dart';
// // import '../orders/orders_screen.dart';
// // import '../coupons/coupons_screen.dart';
// // import '../posters/posters_screen.dart';
// // import '../notifications/notifications_screen.dart';

// // class DashboardScreen extends StatelessWidget {
// //   const DashboardScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Dashboard"),
// //         backgroundColor: Colors.green,
// //         centerTitle: true,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(10),
// //         child: GridView.count(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 10,
// //           mainAxisSpacing: 10,
// //           children: [
// //             _buildCard(context, "Category", Icons.category, const CategoryScreen()),
// //             _buildCard(context, "Subcategory", Icons.list, const SubcategoryScreen()),
// //             _buildCard(context, "Brands", Icons.branding_watermark, const BrandsScreen()),
// //             _buildCard(context, "Orders", Icons.shopping_cart, const OrdersScreen()),
// //             _buildCard(context, "Coupons", Icons.card_giftcard, const CouponsScreen()),
// //             _buildCard(context, "Posters", Icons.image, const PostersScreen()),
// //             _buildCard(context, "Notifications", Icons.notifications, const NotificationsScreen()),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCard(BuildContext context, String title, IconData icon, Widget screen) {
// //     return Card(
// //       elevation: 4,
// //       child: InkWell(
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => screen),
// //           );
// //         },
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(icon, size: 40, color: Colors.green),
// //             const SizedBox(height: 10),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import '../category/category_screen.dart';
// import '../subcategory/subcategory_screen.dart';
// import '../brands/brands_screen.dart';
// import '../orders/orders_screen.dart';
// import '../coupons/coupons_screen.dart';
// import '../posters/posters_screen.dart';
// import '../notifications/notifications_screen.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   // Your brand colors
//   final Color primaryColor = const Color.fromARGB(255, 37, 31, 189); // green shade
//   final Color secondaryColor = const Color(0xFF00BFFF); // accent blue
//   final Color cardBackground = Colors.white;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home),
//             tooltip: "Go to Home",
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const DashboardScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             const Text(
//               "Welcome to DreamArise",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             // Responsive grid
//             Expanded(
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   // Adjust crossAxisCount based on width
//                   int crossAxisCount = constraints.maxWidth > 800
//                       ? 4
//                       : constraints.maxWidth > 600
//                           ? 3
//                           : 2;

//                   return GridView.count(
//                     crossAxisCount: crossAxisCount,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                     children: [
//                       _buildCard(context, "Category", Icons.category, const CategoryScreen()),
//                       _buildCard(context, "Subcategory", Icons.list, const SubcategoryScreen()),
//                       _buildCard(context, "Brands", Icons.branding_watermark, const BrandsScreen()),
//                       _buildCard(context, "Orders", Icons.shopping_cart, const OrdersScreen()),
//                       _buildCard(context, "Coupons", Icons.card_giftcard, const CouponsScreen()),
//                       _buildCard(context, "Posters", Icons.image, const PostersScreen()),
//                       _buildCard(context, "Notifications", Icons.notifications, const NotificationsScreen()),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, String title, IconData icon, Widget screen) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => screen),
//         );
//       },
//       child: Card(
//         color: cardBackground,
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         shadowColor: Colors.grey.withOpacity(0.3),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: secondaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 40, color: secondaryColor),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }