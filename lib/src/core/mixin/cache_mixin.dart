import 'package:ozro_mobile/src/config/router/app_routes.dart';

mixin CacheMixin {
  Future<void> setUserInfo({
    required String name,
    required String id,
    required String login,
    required String email,
    required String accessToken,
    required String imageUrl,
  }) async {
    await localSource.setUser(
      name: name,
      userId: id,
      email: email,
      accessToken: accessToken,
      imageUrl: imageUrl,
    );
  }
}
