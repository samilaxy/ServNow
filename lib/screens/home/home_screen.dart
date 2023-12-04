import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/details_page_provider.dart';
import '../../controllers/home_provider.dart';
import '../../main.dart';
import '../../screens/components/shimmer_loader.dart';
import '../../utilities/constants.dart';
import '../components/servie_card.dart';
import 'service_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  int selectedIndex = 0;
  final List<String> _categories = [
    'General',
    'Barbers',
    'Hair Dressers',
    'Plumbers',
    'Fashion',
    'Mechanics',
    "Home Services",
    "Health & Fitness",
    "Others"
  ];
  @override
  void didPush() {
    final homeProvider = Provider.of<HomeProvider>(context);
    homeProvider.fetchAllServices();
    super.didPush();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final detailsProvider = Provider.of<DetailsPageProvider>(context);

    return Scaffold(
        appBar: const CustomAppBar(),
        body: Container(
          child: homeProvider.dataState
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: mainColor,
                        strokeWidth: 6,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Please wait, while services load...",
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                )
              : Builder(builder: (context) {
                  return CustomScrollView(slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 35, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex =
                                        index; // Update the selected index
                                    homeProvider.filtersServices(index);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Adjust the radius as needed
                                    color: selectedIndex == index
                                        ? mainColor // Highlight selected item
                                        : const Color.fromARGB(255, 225, 220,
                                            220), // Background color
                                  ),
                                  // height: 30,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(_categories[index],
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: selectedIndex == index
                                                ? Colors.white
                                                : Colors.black)),
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 16,
                          left: 16,
                          bottom: 50), // Adjust the padding as needed
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (homeProvider.data.isEmpty) {
                              return Center(
                                child: Text(
                                  "No service created yet",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              );
                            } else {
                              return GridTile(
                                  child: GestureDetector(
                                onTap: () {
                                  detailsProvider.serviceData =
                                      homeProvider.data[index];
                                  detailsProvider.fetchDiscoverServices();
                                  detailsProvider.fetchRelatedServices();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ServiceDetailsPage(),
                                    ),
                                  );
                                },
                                child: homeProvider.dataState
                                    ? const LoadingIndicator()
                                    : ServiceCard(
                                        service: homeProvider.data[index]),
                              ));
                            }
                          },
                          childCount: homeProvider.data.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 210),
                      ),
                    ), // MainView(
                    //   homeProvider: homeProvider,
                    //   detailsProvider: detailsProvider)
                  ]);
                }),
        ));
  }
}

class MainView extends StatelessWidget {
  const MainView({
    super.key,
    required this.homeProvider,
    required this.detailsProvider,
  });

  final HomeProvider homeProvider;
  final DetailsPageProvider detailsProvider;

  @override
  Widget build(BuildContext context) {
    return MainGridView(
        homeProvider: homeProvider, detailsProvider: detailsProvider);
  }
}

class MainGridView extends StatelessWidget {
  const MainGridView({
    super.key,
    required this.homeProvider,
    required this.detailsProvider,
  });

  final HomeProvider homeProvider;
  final DetailsPageProvider detailsProvider;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.77,
            crossAxisSpacing: 10.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        itemCount: homeProvider.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              detailsProvider.serviceData = homeProvider.data[index];
              detailsProvider.fetchDiscoverServices();
              detailsProvider.fetchRelatedServices();
              // Navigate to the details page here, passing data[index] as a parameter
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceDetailsPage(),
                  //                    builder: (context) => ServiceDetailsPage(homeProvider.data[index]),
                ),
              );
            },
            child: homeProvider.dataState
                ? const LoadingIndicator()
                : Flexible(
                    child: ServiceCard(service: homeProvider.data[index]),
                  ),
          );
        });
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                logoImg,
                width: 100,
                height: 100,
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       // ProfileProvider.colorMode();
            //     },
            //     icon: Padding(
            //       padding: const EdgeInsets.only(right: 20),
            //       child: Icon(isDark
            //           ? LineAwesomeIcons.sun
            //           : LineAwesomeIcons.horizontal_ellipsis),
            //     ))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
