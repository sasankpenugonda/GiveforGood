import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givelive/models/donation_model.dart';
import 'package:givelive/utils/utils.dart';

class DonationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DonationModel> _donations = [];
  List<DonationModel> _userDonations = [];
  bool _isLoading = false;

  List<DonationModel> get donations => _donations;
  List<DonationModel> get userDonations => _userDonations;
  bool get isLoading => _isLoading;

  Future<void> createDonation({
    required BuildContext context,
    required String title,
    required String description,
    required String location,
    required int adultsCount,
    required int childrenCount,
    required DateTime expiresAt,
    String? imageUrl,
    double? fundingGoal,
    List<String> tags = const [],
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      final userName = '${userData?['fname'] ?? ''} ${userData?['lname'] ?? ''}'.trim();

      final donationId = _firestore.collection('donations').doc().id;
      final donation = DonationModel(
        id: donationId,
        donorId: user.uid,
        donorName: userName.isEmpty ? 'Anonymous' : userName,
        title: title,
        description: description,
        location: location,
        imageUrl: imageUrl ?? 'https://images.pexels.com/photos/6995247/pexels-photo-6995247.jpeg',
        adultsCount: adultsCount,
        childrenCount: childrenCount,
        targetCount: adultsCount + childrenCount,
        createdAt: DateTime.now(),
        expiresAt: expiresAt,
        fundingGoal: fundingGoal,
        tags: tags,
      );

      await _firestore.collection('donations').doc(donationId).set(donation.toMap());
      
      showSnackbar(context, 'Donation request created successfully!');
      await fetchDonations();
    } catch (e) {
      showSnackbar(context, 'Error creating donation: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDonations() async {
    try {
      _isLoading = true;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('donations')
          .orderBy('createdAt', descending: true)
          .get();

      _donations = querySnapshot.docs
          .map((doc) => DonationModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching donations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserDonations() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('donations')
          .where('donorId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      _userDonations = querySnapshot.docs
          .map((doc) => DonationModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching user donations: $e');
    }
  }

  Future<void> updateDonationProgress({
    required String donationId,
    required int servedCount,
    required BuildContext context,
  }) async {
    try {
      await _firestore.collection('donations').doc(donationId).update({
        'currentServed': FieldValue.increment(servedCount),
      });

      showSnackbar(context, 'Progress updated successfully!');
      await fetchDonations();
    } catch (e) {
      showSnackbar(context, 'Error updating progress: ${e.toString()}');
    }
  }

  Future<void> completeDonation({
    required String donationId,
    required BuildContext context,
  }) async {
    try {
      await _firestore.collection('donations').doc(donationId).update({
        'status': 'completed',
      });

      showSnackbar(context, 'Donation marked as completed!');
      await fetchDonations();
    } catch (e) {
      showSnackbar(context, 'Error completing donation: ${e.toString()}');
    }
  }

  List<DonationModel> get activeDonations => 
      _donations.where((d) => d.isActive).toList();

  List<DonationModel> get nearbyDonations => 
      activeDonations.take(10).toList(); // Simple implementation

  Stream<List<DonationModel>> getDonationsStream() {
    return _firestore
        .collection('donations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DonationModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }
}