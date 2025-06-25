class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String creatorId;
  final List<String> memberIds;
  final List<String> donationIds;
  final DateTime createdAt;
  final String type; // individual, organization
  final bool isVerified;
  final int totalDonations;
  final int totalPeopleServed;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.creatorId,
    this.memberIds = const [],
    this.donationIds = const [],
    required this.createdAt,
    this.type = 'individual',
    this.isVerified = false,
    this.totalDonations = 0,
    this.totalPeopleServed = 0,
  });

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      creatorId: map['creatorId'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      donationIds: List<String>.from(map['donationIds'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      type: map['type'] ?? 'individual',
      isVerified: map['isVerified'] ?? false,
      totalDonations: map['totalDonations'] ?? 0,
      totalPeopleServed: map['totalPeopleServed'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'creatorId': creatorId,
      'memberIds': memberIds,
      'donationIds': donationIds,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'type': type,
      'isVerified': isVerified,
      'totalDonations': totalDonations,
      'totalPeopleServed': totalPeopleServed,
    };
  }

  int get memberCount => memberIds.length;
}