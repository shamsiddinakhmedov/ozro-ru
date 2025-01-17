import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/app_keys.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/formatters/custom_text_input_formatter.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/profile/edit_profile/edit_profile_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/edit_profile/widgets/user_image_widget.dart';
import 'package:permission_handler/permission_handler.dart';

part 'widgets/select_image_bottom_sheet.dart';

part 'mixin/edit_profile_page_mixin.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with _EditProfilePageMixin {
  ValueNotifier<bool> isVisiblePassword = ValueNotifier(false);
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> emailForm = GlobalKey<FormState>();
  final GlobalKey<FormState> nameForm = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordForm = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<EditProfileBloc>().add(const EditProfileInitialEvent());
    _nameController = TextEditingController(text: localSource.name);
    _emailController = TextEditingController(text: localSource.email);
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    isVisiblePassword.dispose();
    emailForm.currentState?.dispose();
    nameForm.currentState?.dispose();
    passwordForm.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<EditProfileBloc, EditProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context).pop();
          } else if (state.status.isError) {
            showFlashError(context: context, content: state.errorMessage);
          }
        },
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) => ModalProgressHUD(
            inAsyncCall: state.status.isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: ValueListenableBuilder(
                  valueListenable: localSource.box.listenable(
                    keys: [AppKeys.name],
                  ),
                  builder: (_, value, __) => GestureDetector(
                    onHorizontalDragEnd: (detail) {
                      if (localSource.isSuperAdmin) {
                        context.pushNamed(Routes.superAdmin);
                      }
                    },
                    onLongPress: () async {
                      await _superAdminStart(longPress: true);
                    },
                    onTap: () {
                      _superAdminStart(simpleFiveTimesPress: true);
                    },
                    onDoubleTap: () {
                      _superAdminStart(doubleFiveTimesPress: true);
                    },
                    child: Text(value.get(AppKeys.name)),
                  ),
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: AppUtils.kPaddingAll32,
                    sliver: SliverToBoxAdapter(
                      child: UserImageWidget(
                        imageUrl: state.imageUrl,
                        defaultWord: localSource.name,
                        imageFile: state.image,
                        onTap: () {
                          customModalBottomSheet<void>(
                            context: context,
                            builder: (_, controller) => BlocProvider.value(
                              value: context.read<EditProfileBloc>(),
                              child: const _ShowSelectImageSheet(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: AppUtils.kPaddingAll16,
                    sliver: DecoratedSliver(
                      decoration: BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius16,
                        color: context.colorScheme.surface,
                      ),
                      sliver: SliverPadding(
                        padding: AppUtils.kPaddingAll10,
                        sliver: SliverList.list(
                          children: [
                            Text(
                              'Заполните информацию',
                              style: context.textStyle.bodyBody.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppUtils.kGap12,
                            Form(
                              key: nameForm,
                              child: CustomTextField(
                                // isRequired: true,
                                titleText: 'ФИО',
                                hintText: 'Введите',
                                filled: true,
                                fillColor: context.color.lightGrey4,
                                controller: _nameController,
                                onChanged: (p0) {
                                  context.read<EditProfileBloc>().add(
                                        EditProfileNameChangedEvent(p0 ?? ''),
                                      );
                                  if (_nameController.text.isNotEmpty) {
                                    nameForm.currentState!.validate();
                                  }
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Введите имя';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            AppUtils.kGap12,
                            ValueListenableBuilder(
                              valueListenable: isVisiblePassword,
                              builder: (_, value, __) => Form(
                                key: passwordForm,
                                child: CustomTextField(
                                  // isRequired: true,
                                  titleText: 'Пароль',
                                  hintText: 'Введите',
                                  filled: true,
                                  fillColor: context.color.lightGrey4,
                                  obscureText: !value,
                                  controller: _passwordController,
                                  onChanged: (p0) {
                                    context.read<EditProfileBloc>().add(
                                          EditProfilePasswordChangedEvent(p0 ?? ''),
                                        );
                                    if (_passwordController.text.isNotEmpty) {
                                      passwordForm.currentState!.validate();
                                    }
                                  },
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Введите пароль';
                                    }
                                    return null;
                                  },
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      isVisiblePassword.value = !value;
                                    },
                                    child: Icon(
                                      value ? Icons.visibility_rounded : Icons.visibility_off_outlined,
                                      size: 24,
                                      color: context.color.midGrey4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AppUtils.kGap12,
                            Form(
                              key: emailForm,
                              child: CustomTextField(
                                // isRequired: true,
                                titleText: 'Email',
                                hintText: 'Введите',
                                filled: true,
                                fillColor: context.color.lightGrey4,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [EmailInputFormatter()],
                                onChanged: (p0) {
                                  context.read<EditProfileBloc>().add(
                                        EditProfileEmailChangedEvent(p0 ?? ''),
                                      );
                                  if (_emailController.text.isNotEmpty) {
                                    emailForm.currentState!.validate();
                                  }
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Введите email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationButton(
                child: ElevatedButton(
                  onPressed: () {
                    if (nameForm.currentState!.validate() &&
                        emailForm.currentState!.validate()
                        // &&
                        // passwordForm.currentState!.validate()
                    ) {
                      context.read<EditProfileBloc>().add(const EditProfileSubmitEvent());
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ),
          ),
        ),
      );
}
