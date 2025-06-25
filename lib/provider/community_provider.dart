import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givelive/models/community_model.dart';
import 'package:givelive/utils/utils.dart';

class CommunityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CommunityModel> _communities = [];
  List<CommunityModel> _userCommunities = [];
  bool _isLoading = false;

  List<CommunityModel> get communities => _communities;
  List<CommunityModel> get userCommunities => _userCommunities;
  bool get isLoading => _isLoading;

  Future<void> createCommunity({
    required BuildContext context,
    required String name,
    required String description,
    required String location,
    String? imageUrl,
    String type = 'individual',
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final communityId = _firestore.collection('communities').doc().id;
      final community = CommunityModel(
        id: communityId,
        name: name,
        description: description,
        imageUrl: imageUrl ?? 'https://images.pexels.com/photos/1157557/pexels-photo-1157557.jpeg',
        location: location,
        creatorId: user.uid,
        memberIds: [user.uid], // Creator is first member
        createdAt: DateTime.now(),
        type: type,
      );

      await _firestore.collection('communities').doc(communityId).set(community.toMap());
      
      showSnackbar(context, 'Community created successfully!');
      await fetchCommunities();
    } catch (e) {
      showSnackbar(context, 'Error creating community: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCommunities() async {
    try {
      _isLoading = true;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('communities')
          .orderBy('totalPeopleServed', descending: true)
          .get();

      _communities = querySnapshot.docs
          .map((doc) => CommunityModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching communities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserCommunities() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('communities')
          .where('memberIds', arrayContains: user.uid)
          .get();

      _userCommunities = querySnapshot.docs
          .map((doc) => CommunityModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching user communities: $e');
    }
  }

  Future<void> joinCommunity({
    required String communityId,
    required BuildContext context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('communities').doc(communityId).update({
        'memberIds': FieldValue.arrayUnion([user.uid]),
      });

      showSnackbar(context, 'Joined community successfully!');
      await fetchCommunities();
      await fetchUserCommunities();
    } catch (e) {
      showSnackbar(context, 'Error joining community: ${e.toString()}');
    }
  }

  Future<void> leaveCommunity({
    required String communityId,
    required BuildContext context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('communities').doc(communityId).update({
        'memberIds': FieldValue.arrayRemove([user.uid]),
      });

      showSnackbar(context, 'Left community successfully!');
      await fetchCommunities();
      await fetchUserCommunities();
    } catch (e) {
      showSnackbar(context, 'Error leaving community: ${e.toString()}');
    }
  }

  List<CommunityModel> get topCommunities => 
      _communities.take(6).toList();

  bool isUserMember(String communityId) {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    final community = _communities.firstWhere(
      (c) => c.id == communityId,
      orElse: () => CommunityModel(
        id: '',
        name: '',
        description: '',
        imageUrl: '',
        location: '',
        creatorId: '',
        createdAt: DateTime.now(),
      ),
    );
    
    return community.memberIds.contains(user.uid);
  }
}