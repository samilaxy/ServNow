import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/details_page_provider.dart';
import '../../controllers/home_provider.dart';
import '../../utilities/constants.dart';
import '../components/servie_card.dart';
import '../components/shimmer_loader.dart';
import 'service_details_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchTextController = TextEditingController();
  bool showClearButton = false;
  bool showButton = true;
  late SearchBar searchBar;
  String searchQuery = '';

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final detailsProvider = Provider.of<DetailsPageProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        cursorColor: mainColor,
                        keyboardType: TextInputType.text,
                        controller: searchTextController,
                        style: const TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          homeProvider.searchServices(value);
                        },
                        onTap: () {
                          setState(() {
                            showClearButton =
                                searchTextController.text.isNotEmpty;
                            showButton = true;
                          });
                        },
                        onChanged: (text) {
                          setState(() {
                            showClearButton = text.isNotEmpty;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            focusColor: mainColor,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            labelStyle: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Search ",
                            // label: const Text("Search "),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: const Icon(
                              size: 15,
                              LineAwesomeIcons.search_solid,
                              color: Colors.grey,
                            ),
                            suffixIcon: Visibility(
                              visible: showClearButton,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchTextController.text = '';
                                    homeProvider.fetchAllServices();
                                    showClearButton = false;
                                    homeProvider.noSearchData = false;
                                  });
                                },
                                child: const Icon(
                                  size: 15,
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                              ),
                            )),
                      ),
                    ),
                    Visibility(
                      visible: showButton,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'home');
                          },
                          child: Text(
                            "Close",
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Stack(children: [
              if (homeProvider.noSearchData)
                Center(
                  child: Text(
                    "No result found",
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              homeProvider.searchState
                  ? Center(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: mainColor, strokeWidth: 6),
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
                      ),
                    )
                  : Builder(builder: (context) {
                      return CustomScrollView(slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.only(
                              top: 10.0,
                              right: 16,
                              left: 16,
                              bottom: 50), // Adjust the padding as needed
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return GridTile(
                                    child: GestureDetector(
                                  onTap: () {
                                    detailsProvider.serviceData =
                                        homeProvider.searchData[index];
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
                                  child: homeProvider.searchState
                                      ? const LoadingIndicator()
                                      : ServiceCard(
                                          service:
                                              homeProvider.searchData[index]),
                                ));
                              },
                              childCount: homeProvider.searchData.length,
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
                    })
            ]))
          ],
        ));
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
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
