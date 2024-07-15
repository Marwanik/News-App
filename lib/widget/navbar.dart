import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/navbar/navbar_bloc.dart';
import 'package:newsapp/bloc/navbar/navbar_event.dart';
import 'package:newsapp/bloc/navbar/navbar_state.dart';

import 'package:newsapp/design/colors.dart';
import 'package:newsapp/view/bookmark/bookmark_Screen.dart';
import 'package:newsapp/view/home/home_screen.dart';


import 'package:newsapp/view/profile/profileScreen.dart';
import 'package:newsapp/view/search/searchScreen.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    BookmarkedNewsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarBloc(),
      child: Scaffold(
        body: BlocBuilder<NavBarBloc, NavBarState>(
          builder: (context, state) {
            if (state is PageLoadedState) {
              return _pages[state.pageIndex];
            }
            return Container(); // Default empty container
          },
        ),
        bottomNavigationBar: BlocBuilder<NavBarBloc, NavBarState>(
          builder: (context, state) {
            int _pageIndex = 0;
            if (state is PageLoadedState) {
              _pageIndex = state.pageIndex;
            }
            return Stack(
              children: [
                CurvedNavigationBar(
                  index: _pageIndex,
                  items: [
                    _buildNavBarItem("assets/image/navbar/home.png", "assets/image/navbar/outlinehome.png", 'Home', _pageIndex, 0),
                    _buildNavBarItem("assets/image/navbar/search.png", "assets/image/navbar/outlinesearch.png", 'Search', _pageIndex, 1),
                    _buildNavBarItem("assets/image/navbar/save.png", "assets/image/navbar/outlinesave.png", 'Favorite', _pageIndex, 2),
                    _buildNavBarItem("assets/image/navbar/profile.png", "assets/image/navbar/profile.png", 'Profile', _pageIndex, 3),
                  ],
                  color: PrimaryColor,
                  buttonBackgroundColor: NavBarChoose,
                  backgroundColor: IconsWhite,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 600),
                  onTap: (index) {
                    context.read<NavBarBloc>().add(ChangePageEvent(index));
                  },
                ),
                Positioned(
                  bottom: 7,
                  left: 33,
                  right: 0,
                  child: _buildNavBarLabel('Home', 0, _pageIndex),
                ),
                Positioned(
                  bottom: 7,
                  left: 135,
                  child: _buildNavBarLabel('Search', 1, _pageIndex),
                ),
                Positioned(
                  bottom: 7,
                  left: 235,
                  child: _buildNavBarLabel('Favorite', 2, _pageIndex),
                ),
                Positioned(
                  bottom: 7,
                  left: 340,
                  child: _buildNavBarLabel('Profile', 3, _pageIndex),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavBarItem(String selectedIconPath, String unselectedIconPath, String label, int currentIndex, int index) {
    return Image.asset(
      currentIndex == index ? selectedIconPath : unselectedIconPath,
      width: 30,
      height: 30,
      color: Colors.white,
    );
  }

  Widget _buildNavBarLabel(String label, int index, int currentIndex) {
    return currentIndex == index
        ? Text(
      label,
      style: TextStyle(
        color: IconsWhite,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    )
        : const SizedBox.shrink();
  }
}

