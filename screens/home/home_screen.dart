import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/ad_banner.dart';
import '../../widgets/product_cart.dart';
import '../../widgets/custom_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_screen.dart';
import '../cart/cart_screen.dart';
import '../saved/saved_screen.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  int _bannerIndex = 0;

  final PageController _pageController = PageController(viewportFraction: 0.93);

  Timer? _timer;

  // Mock data for promotions
  final List<Map<String, String>> promotions = [
    {
      "image": "assets/images/Background.png", 
      "title": "Super Sale 50% Off", 
      "subtitle": "On all electronics"
    },
    {
      "image": "assets/images/Background.png", 
      "title": "New Arrivals", 
      "subtitle": "Discover the latest fashion"
    },
    {
      "image": "assets/images/Background.png", 
      "title": "Fast Delivery", 
      "subtitle": "Get it in 24 hours"
    },
    {
      "image": "assets/images/Background.png", 
      "title": "Weekend Deal", 
      "subtitle": "Exclusive app prices"
    },
  ];

  // Mock data for categories
  final List<String> categories = ["All", "Electronics", "Fashion", "Sneakers", "Watch", "Bags", "Home"];
  int _selectedCategoryIndex = 0;

  // Mock data for products is now handled by ProductProvider

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_bannerIndex < 3) {
          _bannerIndex++;
        } else {
          _bannerIndex = 0;
        }

        _pageController.animateToPage(
          _bannerIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // 📂 MODERNISED DRAWER (MENU) 
      drawer: const CustomDrawer(),

      body: IndexedStack(
        index: _currentIndex == 3 ? 0 : _currentIndex,
        children: [
          SafeArea(
            child: Consumer<ProductProvider>(
              builder: (ctx, productsData, child) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Section
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: const Icon(Icons.menu, size: 28, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: const [
                            SizedBox(width: 12),
                            Icon(Icons.search, color: Colors.grey, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Search on DreamArise",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage('assets/images/Background.png'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Banner Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: promotions.length,
                      onPageChanged: (index) {
                        setState(() {
                          _bannerIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AdBanner(promo: promotions[index], index: index);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(promotions.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _bannerIndex == index ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _bannerIndex == index ? Colors.orangeAccent : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Category Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF003366) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF003366) : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Popular Products",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                    )
                  ],
                ),
              ),
            ),

            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75, // Ideal ratio for product cards
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCard(product: productsData.items[index]);
                  },
                  childCount: productsData.items.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
        const CartScreen(),
        const SavedScreen(),
        const SizedBox.shrink(),
      ],
    ), // Added closing parenthesis here for IndexedStack

      // 🔻 FLOATING NAV BAR REVISED
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navItem(Icons.home_filled, "Home", 0),
                _navItem(Icons.shopping_cart_outlined, "Cart", 1),
                _navItem(Icons.favorite_border, "Saved", 2),
                _navItem(Icons.person_outline, "Account", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    
    Widget iconWidget = Icon(
      icon,
      color: isSelected ? const Color(0xFF003366) : Colors.grey.shade400,
      size: 26,
    );

    if (index == 1) {
      iconWidget = Consumer<CartProvider>(
        builder: (_, cart, ch) => Badge(
          label: Text(cart.itemCount.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
          isLabelVisible: cart.itemCount > 0,
          backgroundColor: Colors.redAccent,
          child: ch,
        ),
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: () {
        if (index == 1 || index == 2 || index == 3) {
          if (Supabase.instance.client.auth.currentSession == null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const DreamAriseLoginScreen()));
            return;
          }
        }

        if (index == 3) {
          _scaffoldKey.currentState?.openDrawer();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF003366) : Colors.grey.shade500,
            ),
          )
        ],
      ),
    );
  }
}