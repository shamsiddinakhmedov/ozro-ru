import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/app_keys.dart';
import 'package:ozro_mobile/src/core/mixin/cache_mixin.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/domain/repositories/auth/auth_repository.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> with CacheMixin {
  EditProfileBloc({
    required this.authRepository,
  }) : super(const EditProfileState()) {
    on<EditProfileInitialEvent>(_editProfileInitialHandler);
    on<EditProfileNameChangedEvent>(_onNameChangedEvent);
    on<EditProfilePasswordChangedEvent>(_onPasswordChangedEvent);
    on<EditProfileEmailChangedEvent>(_onEmailChangedEvent);
    on<EditProfileChangePhotoEvent>(_onChangePhoto);
    on<EditProfileRemovePhotoEvent>(_onRemovePhoto);
    on<EditProfileSubmitEvent>(_onEditProfile);
  }

  final AuthRepository authRepository;

  void _onNameChangedEvent(
    EditProfileNameChangedEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(
      name: event.value,
    ));
  }

  void _onPasswordChangedEvent(
    EditProfilePasswordChangedEvent event,
    Emitter<EditProfileState> emit,
  ) =>
      emit(state.copyWith(password: event.value));

  void _onEmailChangedEvent(
    EditProfileEmailChangedEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(),
    );
  }

  Future<void> _editProfileInitialHandler(
    EditProfileInitialEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        name: localSource.name,
        email: localSource.email,
        imageUrl: localSource.imageUrl,
      ),
    );
  }

  Future<void> _onEditProfile(
    EditProfileSubmitEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    debugPrint('DO FUNCTION: EditProfileBloc _onEditProfile');
    emit(state.copyWith(status: ApiStatus.loading));

    final result = await authRepository.editProfile(
      request: {
        'full_name': state.name,
        'email': state.email,
        if (state.image != null) 'profile_photo': await MultipartFile.fromFile(state.image!.path),
        if (state.password.isNotEmpty) 'password': state.password,
      },
    );

    await result.fold(
      (l) {
        emit(
          state.copyWith(
            status: ApiStatus.error,
            errorMessage: l.message,
          ),
        );
      },
      (r) async {
        // debugLog('email updated: ${event.request.email}');
        await localSource.setUser(
          name: state.name,
          email: state.email,
        );
        if (state.image != null && r.profilePhoto != null) {
          await localSource.box.put(AppKeys.imageUrl, r.profilePhoto);
        }
        emit(state.copyWith(status: ApiStatus.success));
      },
    );
  }

  Future<void> _onChangePhoto(EditProfileChangePhotoEvent event, Emitter<EditProfileState> emit) async {
    emit(
      state.copyWith(image: event.image),
    );
  }

  void _onRemovePhoto(EditProfileRemovePhotoEvent event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(removeImage: true));
  }
}
