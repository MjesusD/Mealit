class UserProfile {
  final String name;
  final int age;
  final String bio;
  final String profileImage;
  final List<String> galleryImages;
  final double heightCm;
  final double weightKg;
  final String dietaryHabits;
  final List<String> dietaryPreferences;
  final List<String> favoriteMealsIds;

  UserProfile({
    required this.name,
    required this.age,
    required this.bio,
    required this.profileImage,
    required this.galleryImages,
    required this.heightCm,
    required this.weightKg,
    required this.dietaryHabits,
    required this.dietaryPreferences,
    required this.favoriteMealsIds,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? '',
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
      heightCm: (json['heightCm'] ?? 0).toDouble(),
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      dietaryHabits: json['dietaryHabits'] ?? '',
      dietaryPreferences: List<String>.from(json['dietaryPreferences'] ?? []),
      favoriteMealsIds: List<String>.from(json['favoriteMealsIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'bio': bio,
        'profileImage': profileImage,
        'galleryImages': galleryImages,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'dietaryHabits': dietaryHabits,
        'dietaryPreferences': dietaryPreferences,
        'favoriteMealsIds': favoriteMealsIds,
      };

  UserProfile copyWith({
    String? name,
    int? age,
    String? bio,
    String? profileImage,
    List<String>? galleryImages,
    double? heightCm,
    double? weightKg,
    String? dietaryHabits,
    List<String>? dietaryPreferences,
    List<String>? favoriteMealsIds,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      galleryImages: galleryImages ?? this.galleryImages,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      dietaryHabits: dietaryHabits ?? this.dietaryHabits,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      favoriteMealsIds: favoriteMealsIds ?? this.favoriteMealsIds,
    );
  }
}
