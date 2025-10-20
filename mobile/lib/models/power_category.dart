class PowerCategory {
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;

  const PowerCategory({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.sortOrder = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory PowerCategory.fromJson(Map<String, dynamic> json) {
    return PowerCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserPowerSelection {
  final int id;
  final int userId;
  final int powerCategoryId;
  final DateTime selectedAt;
  final int priority;
  final PowerCategory? powerCategory;

  const UserPowerSelection({
    required this.id,
    required this.userId,
    required this.powerCategoryId,
    required this.selectedAt,
    this.priority = 0,
    this.powerCategory,
  });

  factory UserPowerSelection.fromJson(Map<String, dynamic> json) {
    return UserPowerSelection(
      id: json['id'] as int,
      userId: json['userId'] as int,
      powerCategoryId: json['powerCategoryId'] as int,
      selectedAt: DateTime.parse(json['selectedAt'] as String),
      priority: json['priority'] as int? ?? 0,
      powerCategory: json['powerCategory'] != null
          ? PowerCategory.fromJson(json['powerCategory'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'powerCategoryId': powerCategoryId,
      'selectedAt': selectedAt.toIso8601String(),
      'priority': priority,
      if (powerCategory != null) 'powerCategory': powerCategory!.toJson(),
    };
  }
}


