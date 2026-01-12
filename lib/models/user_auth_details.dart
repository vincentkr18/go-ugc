/// Model class for user authentication details from the API
class UserAuthDetails {
  final String id;
  final String? email;
  final String? phone;
  final String? emailConfirmedAt;
  final String? phoneConfirmedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? lastSignInAt;
  final String? role;
  final Map<String, dynamic>? appMetadata;
  final Map<String, dynamic>? userMetadata;
  final List<UserIdentity>? identities;

  UserAuthDetails({
    required this.id,
    this.email,
    this.phone,
    this.emailConfirmedAt,
    this.phoneConfirmedAt,
    this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
    this.role,
    this.appMetadata,
    this.userMetadata,
    this.identities,
  });

  factory UserAuthDetails.fromJson(Map<String, dynamic> json) {
    return UserAuthDetails(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      emailConfirmedAt: json['email_confirmed_at'] as String?,
      phoneConfirmedAt: json['phone_confirmed_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      lastSignInAt: json['last_sign_in_at'] as String?,
      role: json['role'] as String?,
      appMetadata: json['app_metadata'] as Map<String, dynamic>?,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
      identities: json['identities'] != null
          ? (json['identities'] as List)
              .map((i) => UserIdentity.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'email_confirmed_at': emailConfirmedAt,
      'phone_confirmed_at': phoneConfirmedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_sign_in_at': lastSignInAt,
      'role': role,
      'app_metadata': appMetadata,
      'user_metadata': userMetadata,
      'identities': identities?.map((i) => i.toJson()).toList(),
    };
  }
}

/// Model class for user identity information
class UserIdentity {
  final String? provider;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  UserIdentity({
    this.provider,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory UserIdentity.fromJson(Map<String, dynamic> json) {
    return UserIdentity(
      provider: json['provider'] as String?,
      id: json['id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
