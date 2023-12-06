import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_provider.dart';
import '../../models/service_model.dart';
import '../../screens/components/image_with_placeholder.dart';
import '../../utilities/constants.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    String currency = "GHS ";
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);

    return Container(
      // width: double.infinity,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(
          color: Colors.grey, // Set the border color
          width: 0.3, // Set the border width
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 150.0,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: ImageWithPlaceholder(
                            imageUrl: widget.service.imgUrls[0],
                            placeholderUrl: noImg)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 55,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 5.0),
                          child: Text(
                            widget.service.title,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '$currency${widget.service.price}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 25,
                            height: 25,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    color: Colors.grey,
                                    child: ImageWithPlaceholder(
                                        imageUrl:
                                            widget.service.user?.img ?? "",
                                        placeholderUrl: tProfileImage)))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.service.user?.fullName ?? "",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(fontSize: 12)),
                                Text(widget.service.category,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(fontSize: 8)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    homeProvider.bookmarkService(
                                        widget.service.id);
                                    widget.service.isFavorite =
                                        !widget.service.isFavorite;
                                    // homeProvider.fetchBookmarkServices();
                                  });
                                },
                                icon: Icon(
                                    size: 20,
                                    Icons.bookmark,
                                    color: widget.service.isFavorite
                                        ? mainColor
                                        : Colors.grey)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 10, bottom: 15),
                  child: SizedBox(
                    // height: 10,
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Icon(size: 13, Icons.location_on),
                        ),
                        Flexible(
                            flex: 1,
                            child: Text(widget.service.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 10, color: Colors.grey))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
