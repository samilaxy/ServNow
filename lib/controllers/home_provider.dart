import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../repository/shared_preference.dart';
import 'profile_proviver.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ProfileProvider profile = ProfileProvider();

  List<ServiceModel> _data = [];
  List<ServiceModel> _searchData = [];
  ServiceModel? _serviceData;
  List<ServiceModel> _bookmarkData = [];
  List _bookmarkIds = [];
  bool _dataState = true;
  bool _searchState = false;
  String _category = "";
  String _userId = "";
  bool _noData = true;
  bool _noSearchData = false;
  bool _noFiltaData = false;
  bool _isBook = false;

  Map<String, dynamic>? profileData;
  ServiceModel? get serviceData => _serviceData;
  List get data => _data;
  //List get searchData => _searchData;
  List<ServiceModel> get searchData => _searchData;
  List get bookmarkIds => _bookmarkIds;
  bool get noData => _noData;
  bool get noSearchData => _noSearchData;
  bool get noFiltaData => _noFiltaData;
  bool get isBook => _isBook;
  bool get searchState => _searchState;
  String get userId => _userId;
  String get category => _category;
  List get bookmarkData => _bookmarkData;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;
  bool get dataState => _dataState;
  HomeProvider() {
    fetchAllServices();
    // fetchBookmarkServices();
    _searchData = _data;
  }
  set noSearchData(bool value) {
    _noSearchData = value;
    notifyListeners();
  }

  Future<void> fetchAllServices() async {
    try {
      await profile.fetchUserData;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("services").get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      _data = [];
      // Process the documents and add fetchUserData tasks
      for (var document in documents) {
        final serviceData = document.data();
        final userId = serviceData["userId"];

        // Create a new list for each document
        final List<Future<void>> fetchUserDataTasks = [];

        // Add a task to fetch user data concurrently
        fetchUserDataTasks.add(
          fetchUserData(userId).then((userModel) {
            final serviceCard = ServiceModel(
              id: document.id,
              userId: userId,
              title: serviceData["title"],
              category: serviceData["category"],
              price: serviceData["price"],
              location: serviceData["location"],
              description: serviceData["description"],
              isFavorite: profile.bookmarks.contains(document.id),
              status: serviceData["status"],
              imgUrls: serviceData["imgUrls"],
              user: _userModel,
            );
            _data.add(serviceCard);
            _searchData = List.from(_data);
            notifyListeners();
            if (_data.isNotEmpty) {
              _dataState = false;
              notifyListeners();
            }
          }),
        );

        // Wait for all fetchUserData tasks to complete concurrently for each document
        await Future.wait(fetchUserDataTasks);
      }

      notifyListeners();
    } catch (error) {
      if (_data.isEmpty) {
        _dataState = true;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future<void> filtersServices(int index) async {
    // await Future.delayed(const Duration(seconds: 3));
    //_dataState = true;
    _category = "";
    switch (index) {
      case 1:
        _category = "Barber";
        break;
      case 2:
        _category = "Hair Dresser";
        break;
      case 3:
        _category = "Plumber";
        break;
      case 4:
        _category = "Fashion";
        break;
      case 5:
        _category = "Mechanic";
        break;
      case 6:
        _category = "Home Service";
        break;
      case 7:
        _category = "Health & Fitness";
        break;
      case 8:
        _category = "Others";
        break;
      default:
        _category = "";
    }

    await Future.delayed(const Duration(seconds: 1));
    try {
      if (_category.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collection('services')
            .where('category',
                isEqualTo: _category) // Replace with the user's ID
            .get();

        //if (querySnapshot.exists) {
        //reset discovered items array
        final List<Future<void>> fetchUserDataTasks = [];
        _data = [];

        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> serviceData =
              document.data() as Map<String, dynamic>;
          final userId = serviceData["userId"];

          fetchUserDataTasks.add(
            fetchUserData(userId).then((userModel) {
              final service = ServiceModel(
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
              );
              _data.add(service);
            }),
          );
          if (_data.isNotEmpty) {
            _dataState = false;
            _noFiltaData = false;
          } else {
            print("no1 data");
            _dataState = false;
            _noFiltaData = true;
          }
        }
      } else {
        fetchAllServices();
      }
    } catch (error) {
      _dataState = false;
    }
    notifyListeners();
  }

  Future<void> loadprofileData() async {
    profile.fetchUserData();
    await Future.delayed(const Duration(seconds: 1));
    profileData = await SharedPreferencesHelper.getContact();
    _bookmarkIds = [];
    if (profileData != null) {
      _userId = profileData!['userId'] ?? '';
      _bookmarkIds = profileData!['bookmarks'] ?? [];
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkServices() async {
    await loadprofileData();
    await Future.delayed(const Duration(seconds: 2));
    _noData = true;
    _isBook = false;
    _bookmarkData = [];
    final List<Future<void>> fetchServiceDataTasks = [];

    try {
      for (var document in _bookmarkIds) {
        fetchServiceDataTasks.add(fetchService(document).then((serviceCard) {
          _bookmarkData.add(serviceCard!);
        }));
      }
      await Future.wait(fetchServiceDataTasks);
      if (_bookmarkData.isNotEmpty) {
        _isBook = false; // Data is available
        _noData = false;
      } else {
        // await Future.delayed(const Duration(seconds: 5));
        _noData = false;
        _isBook = true;
      }

      _noData = false; // No data available
    } catch (error) {
      if (_bookmarkData.isEmpty) {
        _isBook = true;
        _noData = false;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> searchServices(String searchQuery) async {
    String newVal = searchQuery[0].toUpperCase() +
        searchQuery
            .substring(1); // To make the first character always on uppercase.

    if (searchQuery.isNotEmpty) {
      try {
        // Show loader

        _searchState = true;
        _searchData = [];
        notifyListeners();

        // Fetch documents where the title contains the search query
        final QuerySnapshot<Map<String, dynamic>> titleQuerySnapshot = await _db
            .collection('services')
            .orderBy("title")
            .startAt([newVal]).endAt([newVal + '\uf8ff']).get();

        await Future.delayed(const Duration(seconds: 2));
        print('$searchQuery,  SNAP SHOT :  ${titleQuerySnapshot.docs.length}');

        final List<QueryDocumentSnapshot<Map<String, dynamic>>> titleDocuments =
            titleQuerySnapshot.docs;

        // Process the documents and add to the _searchData list
        final List<Future<void>> fetchTasks = [];

        for (var document in titleDocuments) {
          final serviceData = document.data();
          final userId = serviceData["userId"];

          // Add a fetch task to the list
          fetchTasks.add(fetchUserData(userId).then((userModel) {
            // Create ServiceModel
            final service = ServiceModel(
              userId: userId,
              title: serviceData["title"],
              category: serviceData["category"],
              price: serviceData["price"],
              location: serviceData["location"],
              description: serviceData["description"],
              isFavorite: serviceData["isFavorite"],
              status: serviceData["status"],
              imgUrls: serviceData["imgUrls"],
              user: userModel,
            );

            // Add the service to _searchData
            _searchData.add(service);
          }));
        }

        // Wait for all concurrent fetch tasks to complete
        await Future.wait(fetchTasks);
        if (_searchData.isNotEmpty) {
          // Hide loader
          _searchState = false;
          _noSearchData = false;
          notifyListeners();
        } else {
          // Delay to show no data text
          //  await Future.delayed(const Duration(seconds: 5));

          // Show no data text
          _noSearchData = true;
          _searchState = false;
          notifyListeners();
        }
      } catch (error) {
        // Handle errors, and notify listeners if needed
        _noSearchData = true;
        _searchState = false;
        notifyListeners();
        print('Error: $error');
      }
      notifyListeners();
    } else {
      _searchData = _data;
      notifyListeners();
    }
  }

  Future<UserModel?> fetchUserData(String documentId) async {
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
            bookmarks: data['bookmarks'] ?? []);
        _bookmarkIds = data['bookmarks'] ?? [];
        notifyListeners();
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {
      _dataState = false;
      notifyListeners();
    }
    notifyListeners();
    return _userModel;
  }

  Future<void> bookmarkService(String? servId, String? userId) async {
    try {
      if (_bookmarkIds.contains(servId)) {
        _bookmarkIds.remove(servId);
      } else {
        _bookmarkIds.add(servId);
      }
      notifyListeners();

      // Update Firestore with the updated bookmarks list
      await _db
          .collection("users")
          .doc(userId)
          .update({'bookmarks': _bookmarkIds});

      // Fetch updated bookmark services after Firestore update
      await fetchBookmarkServices();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<ServiceModel?> fetchService(String servId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('services').doc(servId).get();

      // Check if data exists and is of the expected type
      if (querySnapshot.exists && querySnapshot.data() != null) {
        Map<String, dynamic> data = querySnapshot.data()!;
        final userId = data["userId"];

        final List<Future<void>> fetchUserDataTasks = [];

        fetchUserDataTasks.add(
          fetchUserData(userId).then((userModel) {
            final service = ServiceModel(
              id: servId,
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
            );
            _serviceData = service;

            notifyListeners();
          }),
        );

        await Future.wait(fetchUserDataTasks);
        notifyListeners();
      } else {
        print('No data found for servId: $servId');
      }
    } catch (error) {
      print('Error fetching bookmark data: $error');
    }

    notifyListeners();
    return _serviceData;
  }
}
