import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/news/news_bloc.dart';
import 'package:newsapp/bloc/news/news_event.dart';
import 'package:newsapp/design/colors.dart';
import 'package:newsapp/view/login/loginScreen.dart';
import 'package:newsapp/widget/latestNews.dart';
import 'package:newsapp/widget/newsListwheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  String _username = 'Username';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchNewsForAllCategories();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Username';
    });
  }

  void _fetchNewsForAllCategories() {
    context.read<NewsBloc>().add(GetNewsForAllCategories(categories: categories, page: 1));
  }

  Future<void> _clearCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear only cached news data
    await prefs.remove('cached_news_data');
    // Optionally, you can reload the news or perform other actions after clearing the cache.
    _fetchNewsForAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGround,
      appBar: AppBar(
        surfaceTintColor: BackGround,
        foregroundColor: PrimaryColor,
        backgroundColor: BackGround,
        centerTitle: true,
        title: Text(
          'Grand News',
          style: TextStyle(
            color: TextColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Clear cached data
              _clearCachedData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cached data cleared')),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: NavBarChoose,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              arrowColor: Colors.red,
              decoration: BoxDecoration(color: PrimaryColor),
              accountName: Text(_username),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                radius: 200,
                backgroundImage: AssetImage("assets/image/navbar/profile.png"),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    context.read<NewsBloc>().add(GetNewsData(category: categories[index], page: 1));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedCategoryIndex == index ? Colors.transparent : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: _selectedCategoryIndex == index ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: _selectedCategoryIndex == index ? 20 : 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: TabContent(
              selectedCategoryIndex: _selectedCategoryIndex,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> categories = [
  'general',
  'business',
  'entertainment',
  'health',
  'science',
  'sports',
  'technology',
];

class TabContent extends StatefulWidget {
  final int selectedCategoryIndex;

  const TabContent({Key? key, required this.selectedCategoryIndex}) : super(key: key);

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: Container(
                width: MediaQuery.sizeOf(context).width*.7,
                child: NewsListWheel(selectedCategoryIndex: widget.selectedCategoryIndex)),
          ),
          const SizedBox(height: 40),
          LatestNews(selectedCategoryIndex: widget.selectedCategoryIndex),
        ],
      ),
    );
  }
}
