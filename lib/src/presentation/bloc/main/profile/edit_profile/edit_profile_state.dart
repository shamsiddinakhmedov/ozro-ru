part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.name = '',
    this.image,
    this.status = ApiStatus.initial,
    this.errorMessage = '',
    this.password = '',
    this.email = '',
    this.imageUrl = '',
  });

  final File? image;
  final String name;
  final ApiStatus status;
  final String errorMessage;
  final String password;
  final String email;
  final String imageUrl;

  EditProfileState copyWith({
    String? name,
    File? image,
    ApiStatus? status,
    String? errorMessage,
    bool removeImage = false,
    String? password,
    String? email,
    String? imageUrl,
  }) =>
      EditProfileState(
        name: name ?? this.name,
        image: removeImage ? null : image ?? this.image,
        status: status ?? ApiStatus.initial,
        errorMessage: errorMessage ?? this.errorMessage,
        password: password ?? this.password,
        email: email ?? this.email,
        imageUrl: removeImage ? '' : imageUrl ?? this.imageUrl,
      );

  @override
  List<Object?> get props => [
        name,
        image,
        status,
        errorMessage,
        password,
        email,
        imageUrl,
      ];
}
