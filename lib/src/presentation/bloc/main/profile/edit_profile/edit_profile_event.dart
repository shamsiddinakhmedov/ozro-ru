part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {
  const EditProfileEvent();
}

class EditProfileInitialEvent extends EditProfileEvent {
  const EditProfileInitialEvent();

}

class EditProfileNameChangedEvent extends EditProfileEvent {
  const EditProfileNameChangedEvent(this.value);

  final String value;
}

class EditProfileEmailChangedEvent extends EditProfileEvent {
  const EditProfileEmailChangedEvent(this.value);

  final String value;
}

class EditProfilePasswordChangedEvent extends EditProfileEvent {
  const EditProfilePasswordChangedEvent(this.value);

  final String value;
}

class EditProfileChangePhotoEvent extends EditProfileEvent {
  const EditProfileChangePhotoEvent(this.image);

  final File? image;
}

class EditProfileRemovePhotoEvent extends EditProfileEvent {
  const EditProfileRemovePhotoEvent();
}

class EditProfileSubmitEvent extends EditProfileEvent {
  const EditProfileSubmitEvent();
}
