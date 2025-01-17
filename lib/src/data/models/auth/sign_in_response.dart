class SignInResponse {
  SignInResponse({
    this.token,
    this.user,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        token: json['token'],
        user: json['user'] == null ? null : UserResponse.fromJson(json['user']),
      );
  final String? token;
  final UserResponse? user;

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user?.toJson(),
      };
}


class UserResponse {

  UserResponse(
      {this.id,
        this.email,
        this.fullName,
        this.profilePhoto,
        this.isBlocked,
        this.favoritesCount,
        this.feedbacksCount,
        this.commentsCount,
        this.hasUnreadNotifications});

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    profilePhoto = json['profile_photo'];
    isBlocked = json['is_blocked'];
    favoritesCount = json['favorites_count'];
    feedbacksCount = json['feedbacks_count'];
    commentsCount = json['comments_count'];
    hasUnreadNotifications = json['has_unread_notifications'];
  }
  int? id;
  String? email;
  String? fullName;
  String? profilePhoto;
  bool? isBlocked;
  int? favoritesCount;
  int? feedbacksCount;
  int? commentsCount;
  bool? hasUnreadNotifications;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['full_name'] = fullName;
    data['profile_photo'] = profilePhoto;
    data['is_blocked'] = isBlocked;
    data['favorites_count'] = favoritesCount;
    data['feedbacks_count'] = feedbacksCount;
    data['comments_count'] = commentsCount;
    data['has_unread_notifications'] = hasUnreadNotifications;
    return data;
  }
}






// class UserResponse {
//   UserResponse({
//     this.email,
//     this.fullName,
//     this.profilePhoto,
//     this.favoritesCount,
//     this.commentsCount,
//     this.feedbacksCount,
//   });
//
//   factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
//         email: json['email'],
//         fullName: json['full_name'],
//         profilePhoto: json['profile_photo'],
//         favoritesCount: json['favorites_count'],
//         commentsCount: json['comments_count'],
//         feedbacksCount: json['feedbacks_count'],
//       );
//
//   final String? email;
//   final String? fullName;
//   final String? profilePhoto;
//   final num? favoritesCount;
//   final num? commentsCount;
//   final num? feedbacksCount;
//
//   Map<String, dynamic> toJson() => {
//         'email': email,
//         'full_name': fullName,
//         'profile_photo': profilePhoto,
//         'favorites_count': favoritesCount,
//         'comments_count': commentsCount,
//         'feedbacks_count': feedbacksCount,
//       };
// }
