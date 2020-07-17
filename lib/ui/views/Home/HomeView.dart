import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/ui/views/Home/HomeViewModel.dart';
import 'package:mosque_attendance_app/ui/views/PreviousTab/PreviousTabView.dart';
import 'package:mosque_attendance_app/ui/views/ScannerTab/ScannerTabView.dart';
import 'package:mosque_attendance_app/ui/views/UpcomingTab/UpcomingTabView.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  HomeViewModel _homeViewModel = new HomeViewModel();
  List<Widget> originalList;
  Map<int, bool> originalDic;
  List<Widget> listScreens;
  List<int> listScreensIndex;

  int tabIndex = 0;
  Color tabColor = Colors.blue;
  Color selectedTabColor = Colors.amber;


  void initState() {
    listScreens = [
      ScannerTabView(),
      UpcomingTabView(),
      PreviousTabView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        initState();
        return Scaffold(
          body: IndexedStack(
            index: _homeViewModel.tabIndex, children: listScreens,),
          bottomNavigationBar: _buildBottomNavBar(),
          backgroundColor: Colors.white,
        );
      },
      viewModelBuilder: () => _homeViewModel,
    );
  }


  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _homeViewModel.tabIndex,
        onTap: (int index) {
          _homeViewModel.updateTabIndex(index);

        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.scanner),
            title: Text('Scanner'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_made),
            title: Text('Upcoming'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_missed),
            title: Text('Previous'),
          ),
        ]);
  }
}



