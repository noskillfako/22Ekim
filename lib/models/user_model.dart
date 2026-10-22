class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final int age;
  final String gender; // 'male', 'female', 'unisex'
  final String avatarId;
  final bool isWatchConnected;
  final int smokingBaselineDaily;
  final double smokingPackPrice;
  final double alcoholBaselinePrice;
  final int standardMealCalories;

  const UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.avatarId,
    this.isWatchConnected = false,
    this.smokingBaselineDaily = 20,
    this.smokingPackPrice = 75.0,
    this.alcoholBaselinePrice = 120.0,
    this.standardMealCalories = 800,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    int? age,
    String? gender,
    String? avatarId,
    bool? isWatchConnected,
    int? smokingBaselineDaily,
    double? smokingPackPrice,
    double? alcoholBaselinePrice,
    int? standardMealCalories,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      avatarId: avatarId ?? this.avatarId,
      isWatchConnected: isWatchConnected ?? this.isWatchConnected,
      smokingBaselineDaily: smokingBaselineDaily ?? this.smokingBaselineDaily,
      smokingPackPrice: smokingPackPrice ?? this.smokingPackPrice,
      alcoholBaselinePrice: alcoholBaselinePrice ?? this.alcoholBaselinePrice,
      standardMealCalories: standardMealCalories ?? this.standardMealCalories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'avatarId': avatarId,
      'isWatchConnected': isWatchConnected,
      'smokingBaselineDaily': smokingBaselineDaily,
      'smokingPackPrice': smokingPackPrice,
      'alcoholBaselinePrice': alcoholBaselinePrice,
      'standardMealCalories': standardMealCalories,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? 'user_1',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? 'Kullanıcı',
      age: (json['age'] as num?)?.toInt() ?? 25,
      gender: json['gender'] as String? ?? 'unisex',
      avatarId: json['avatarId'] as String? ?? 'avatar_neutral_adult',
      isWatchConnected: json['isWatchConnected'] as bool? ?? false,
      smokingBaselineDaily: (json['smokingBaselineDaily'] as num?)?.toInt() ?? 20,
      smokingPackPrice: (json['smokingPackPrice'] as num?)?.toDouble() ?? 75.0,
      alcoholBaselinePrice: (json['alcoholBaselinePrice'] as num?)?.toDouble() ?? 120.0,
      standardMealCalories: (json['standardMealCalories'] as num?)?.toInt() ?? 800,
    );
  }
}
