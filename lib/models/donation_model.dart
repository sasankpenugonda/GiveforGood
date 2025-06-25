class DonationModel {
  final String id;
  final String donorId;
  final String donorName;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final int adultsCount;
  final int childrenCount;
  final int currentServed;
  final int targetCount;
  final String status; // active, completed, cancelled
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? organizationId;
  final double? fundingGoal;
  final double? currentFunding;
  final List<String> tags;

  DonationModel({
    required this.id,
    required this.donorId,
    required this.donorName,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.adultsCount,
    required this.childrenCount,
    this.currentServed = 0,
    required this.targetCount,
    this.status = 'active',
    required this.createdAt,
    required this.expiresAt,
    this.organizationId,
    this.fundingGoal,
    this.currentFunding = 0,
    this.tags = const [],
  });

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] ?? '',
      donorId: map['donorId'] ?? '',
      donorName: map['donorName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      adultsCount: map['adultsCount'] ?? 0,
      childrenCount: map['childrenCount'] ?? 0,
      currentServed: map['currentServed'] ?? 0,
      targetCount: map['targetCount'] ?? 0,
      status: map['status'] ?? 'active',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expiresAt'] ?? 0),
      organizationId: map['organizationId'],
      fundingGoal: map['fundingGoal']?.toDouble(),
      currentFunding: map['currentFunding']?.toDouble() ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'donorName': donorName,
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'adultsCount': adultsCount,
      'childrenCount': childrenCount,
      'currentServed': currentServed,
      'targetCount': targetCount,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'organizationId': organizationId,
      'fundingGoal': fundingGoal,
      'currentFunding': currentFunding,
      'tags': tags,
    };
  }

  double get progressPercentage {
    if (targetCount == 0) return 0;
    return (currentServed / targetCount).clamp(0.0, 1.0);
  }

  bool get isActive => status == 'active' && DateTime.now().isBefore(expiresAt);
  bool get isCompleted => status == 'completed' || currentServed >= targetCount;
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}