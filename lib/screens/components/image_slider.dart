

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../screens/components/image_with_placeholder.dart';
import '../../utilities/constants.dart';

import '../home/zoom_imageview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class MyImageSlider extends StatefulWidget {
  final List<dynamic> imageUrls;

  const MyImageSlider({super.key, required this.imageUrls});

  @override
  // ignore: library_private_types_in_public_api
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CarouselSlider(
          //   carouselController: _carouselController,
          //   options: CarouselOptions(
          //     height: 220.0,
          //     aspectRatio: 16 / 9,
          //     autoPlay: false,
          //     autoPlayInterval: const Duration(seconds: 3),
          //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
          //     autoPlayCurve: Curves.fastOutSlowIn,
          //     enlargeCenterPage: false,
          //     scrollDirection: Axis.horizontal,
          //   ),
          //   items: widget.imageUrls.map((imageUrl) {
          //     return Builder(
          //       builder: (BuildContext context) {
          //         return GestureDetector(
          //           onTap: (){
          //             Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                             builder: (context) => ZoomImageView(
          //                                 imageUrl: imageUrl,
          //                         placeholderUrl: noImg,),
          //                           ));
          //           },
          //           child: Container(
          //             color: Colors.grey,
          //             width: MediaQuery.of(context).size.width,
          //             margin: const EdgeInsets.symmetric(horizontal: 5.0),
          //             child: ImageWithPlaceholder(
          //                         imageUrl: imageUrl,
          //                         placeholderUrl: noImg,
          //                       ),
          //           ),
          //         );
          //       },
          //     );
          //   }).toList(),
          // ),
        
         ImageCarousel(
            imageUrls: widget.imageUrls,
          ),
          // Positioned(
          //   top: 0,
          //   bottom: 0,
          //   left: 0,
          //   child: IconButton(
          //     onPressed: () {
          //       _carouselController.previousPage();
          //     },
          //     icon: const Icon(LineAwesomeIcons.angle_left_solid),
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   bottom: 0,
          //   right: 0,
          //   child: IconButton(
          //     onPressed: () {
          //       _carouselController.nextPage();
          //     },
          //     icon: const Icon(LineAwesomeIcons.angle_right_solid),
          //   ),
          // ),
        
        ],
      ),
    );
  }
}



class ImageCarousel extends StatefulWidget {
  final List<dynamic> imageUrls;

  const ImageCarousel({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220.0,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: widget.imageUrls.map((imageUrl) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZoomImageView(
                        imageUrl: imageUrl,
                        placeholderUrl: noImg,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ImageWithPlaceholder(
                    imageUrl: imageUrl,
                    placeholderUrl: noImg,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.imageUrls.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
