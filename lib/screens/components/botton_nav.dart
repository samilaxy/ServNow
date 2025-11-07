import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serv_now_new/screens/home/search.dart';
import '../../controllers/home_provider.dart';
import '../../controllers/profile_proviver.dart';
import '../../main.dart';
import '../../screens/home/boomark_page.dart';
import '../../screens/home/create_service_page.dart';
import '../../screens/home/my_adverts.dart';
import '../../utilities/constants.dart';
import '../home/Home_screen.dart';
import '../profile/profile_page.dart';

class BottomNarBar extends StatefulWidget {
  const BottomNarBar({Key? key}) : super(key: key);

  @override
  State<BottomNarBar> createState() => _BottomNarBarState();
}

class _BottomNarBarState extends State<BottomNarBar> {
  int currentTab = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const MyAdverts(),
    const ProfileScreen(),
    const CreateServicePage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  void onItemTapped(int tab, Widget screen) {
    setState(() {
      currentTab = tab;
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      onItemTapped(0, const HomeScreen());
                      profile.loadprofileData();
                      homeProvider.fetchAllServices();
                    },
                    child: SizedBox(
                      width: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.user,
                            color: currentTab == 0 ? mainColor : Colors.grey,
                          ),
                          Text("Home",
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5,
                                  color: currentTab == 0
                                      ? mainColor
                                      : Colors.grey))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onItemTapped(1, const SearchScreen());
                    },
                    child: SizedBox(
                      width: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.search_plus_solid,
                            color: currentTab == 1 ? mainColor : Colors.grey,
                          ),
                          Text("Search",
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5,
                                  color: currentTab == 1
                                      ? mainColor
                                      : Colors.grey))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String route =
                          profile.isUser ? "createService" : "update";
                      navigatorKey.currentState!.pushNamed(route);
                    },
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: Container(
                        //clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: mainColor,
                        ),
                        // height: 55,
                        // width: 55,
                        child: const Icon(
                          LineAwesomeIcons.plus_solid,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      onItemTapped(2, const BookmarkPage());
                      // await homeProvider.fetchBookmarkServices();
                    },
                    child: SizedBox(
                      width: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.bookmark,
                            color: currentTab == 2 ? mainColor : Colors.grey,
                          ),
                          Text("Bookmarks",
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5,
                                  color: currentTab == 2
                                      ? mainColor
                                      : Colors.grey))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onItemTapped(3, const ProfileScreen());
                      profile.loadprofileData();
                    },
                    child: SizedBox(
                      width: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.user_alt_solid,
                            color: currentTab == 3 ? mainColor : Colors.grey,
                          ),
                          Text("Profile",
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5,
                                  color: currentTab == 3
                                      ? mainColor
                                      : Colors.grey))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
