import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/discover_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import 'home_provider.dart';
import 'profile_proviver.dart';

class DetailsPageProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ServiceModel? _serviceData;
  DiscoverModel? _discoverData;
  String _serId = '';
  int _views = 0;
  List<DiscoverModel> _discover = [];
  List<ServiceModel> _related = [];
  bool _dataState = true;
  UserModel? _userModel;
  HomeProvider homeProvider = HomeProvider();
  ProfileProvider profile = ProfileProvider();

  UserModel? get userModel => _userModel;
  ServiceModel? get serviceData => _serviceData;
  // Define a ValueNotifier for serviceData

  DiscoverModel? get discoverData => _discoverData;
  List get discover => _discover;
  String get serId => _serId;
  int get views => _views;
  List get related => _related;

  bool get dataState => _dataState;

  set serviceData(ServiceModel? value) {
    _serviceData = value;
    updateServiceView(_serviceData?.id ?? "", _serviceData?.views ?? 0);
    notifyListeners();
  }

  DetailsPageProvider() {
    //fetchDiscoverServices();
    // fetchRelatedServices();
  }

  Future<void> fetchDiscoverServices() async {
    await Future.delayed(const Duration(seconds: 2));
    _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('userId',
              isEqualTo: _serviceData?.userId) // Replace with the user's ID
          .get();

      //reset discovered items array
      _discover = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DiscoverModel service = DiscoverModel(
          id: document.id,
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          views: data['views'] ?? '',
          img: data['imgUrls'][0] ?? '',
          status: data['status'],
          comments: data['comments'],
        );
        _discover.add(service);
        if (_discover.isNotEmpty) {
          _dataState = false;
        }
      }
    } catch (error) {
      _dataState = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchRelatedServices() async {
    await Future.delayed(const Duration(seconds: 3));
    _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('category',
              isEqualTo: _serviceData?.category) // Replace with the user's ID
          .get();

      //if (querySnapshot.exists) {
      //reset discovered items array
      final List<Future<void>> fetchUserDataTasks = [];
      _related = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> serviceData =
            document.data() as Map<String, dynamic>;
        final userId = serviceData["userId"];

        fetchUserDataTasks.add(
          fetchUserData(userId).then((userModel) {
            final service = ServiceModel(
              id: document.id,
              userId: userId,
              title: serviceData["title"],
              category: serviceData["category"],
              price: serviceData["price"],
              location: serviceData["location"],
              description: serviceData["description"],
              isFavorite: serviceData["isFavorite"],
              status: serviceData["status"],
              imgUrls: serviceData["imgUrls"],
              user: _userModel,
              views: serviceData["views"],
              comments: serviceData["comments"],
            );
            _related.add(service);
            if (_related.isNotEmpty) {
              _dataState = true;
            }
          }),
        );
      }
    } catch (error) {
      _dataState = false;
    } finally {
      notifyListeners();
    }
  }

  dynamic launchTel(String? path) async {
    try {
      Uri phone = Uri(
        scheme: 'tel',
        path: path,
      );

      await launchUrl(phone);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchService(int index) async {
    // await Future.delayed(const Duration(seconds: 2));
    // _dataState = true;
    _serId = discover[index].id;

    try {
      final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('services').doc(_serId).get();

      // Check if data exists and is of the expected type
      if (querySnapshot.exists && querySnapshot.data() != null) {
        Map<String, dynamic> data = querySnapshot.data()!;
        final userId = data["userId"];

        final List<Future<void>> fetchUserDataTasks = [];

        fetchUserDataTasks.add(
          fetchUserData(userId).then((userModel) {
            final service = ServiceModel(
              id: _serId,
              userId: userId,
              title: data["title"],
              category: data["category"],
              price: data["price"],
              location: data["location"],
              description: data["description"],
              isFavorite: true,
              status: data["status"],
              imgUrls: data["imgUrls"],
              user: _userModel,
              views: data["views"],
              comments: data["comments"],
            );
            _views = data["views"];
            _serviceData = service;
          }),
        );
        await Future.wait(fetchUserDataTasks);
        notifyListeners();
      }
      // ignore: empty_catches
    } catch (error) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchUserData(String documentId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(documentId)
              .get();

      if (documentSnapshot.exists) {
        final Map<String, dynamic> data = documentSnapshot.data()!;
        _userModel = UserModel(
          id: documentId,
          phone: data['phone'] ?? '',
          bio: data['bio'] ?? '',
          email: data['email'] ?? '',
          img: data['img'] ?? '',
          fullName: data['name'] ?? '',
          role: data['role'],
        );
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {
      _dataState = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateServiceView(String servId, int views) async {
    // await Future.delayed(const Duration(seconds: 2));
    int updatedViews = views + 1;
    try {
      // Update Firestore with the updated bookmarks list
      await _db
          .collection("services")
          .doc(servId)
          .update({'views': updatedViews});
    } catch (error) {
      print(error.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> bookmarkService(String? servId) async {
    if (homeProvider.bookmarkIds.contains(servId)) {
      homeProvider.bookmarkIds.remove(servId);
    } else {
      homeProvider.bookmarkIds.add(servId);
    }

    try {
      await _db
          .collection("users")
          .doc(profile.userId)
          .update({'bookmarks': homeProvider.bookmarkIds});

      //  homeProvider.fetchBookmarkServices();
      //  homeProvider.fetchAllServices();
      //  notifyListeners();
    } catch (error) {
      print(error.toString());
    } finally {
      notifyListeners();
    }
  }
}
