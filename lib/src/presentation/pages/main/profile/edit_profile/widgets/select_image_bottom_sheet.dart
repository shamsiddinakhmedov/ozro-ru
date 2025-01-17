part of '../edit_profile_page.dart';

class _ShowSelectImageSheet extends StatelessWidget {
  const _ShowSelectImageSheet();

  @override
  Widget build(BuildContext context) => SafeArea(
        minimum: AppUtils.kPaddingBottom16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.image_outlined,
                color: context.color.midGrey,
              ),
              title: Text(
                'Галерея',
                style: context.textStyle.regularCallout,
              ),
              onTap: () async => _pickImage(context, ImageSource.gallery),
            ),
            AppUtils.kDivider,
            ListTile(
              leading: Icon(
                AppIcons.camera,
                color: context.color.midGrey,
              ),
              title: Text(
                'Камера',
                style: context.textStyle.regularCallout,
              ),
              onTap: () async => _pickImage(context, ImageSource.camera),
            ),
            if (context.read<EditProfileBloc>().state.image != null ||
                context.read<EditProfileBloc>().state.imageUrl.isNotEmpty) ...[
              AppUtils.kDivider,
              ListTile(
                splashColor: context.colorScheme.error.withOpacity(0.1),
                focusColor: context.colorScheme.error.withOpacity(0.1),
                leading: Icon(
                  AppIcons.delete,
                  color: context.colorScheme.error,
                ),
                title: Text(
                  'Удалить',
                  style: context.textStyle.regularCallout.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
                onTap: () async {
                  context.read<EditProfileBloc>().add(const EditProfileRemovePhotoEvent());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ],
        ),
      );

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        await Permission.camera.isDenied.then((value) {
          if (value) {
            Permission.camera.request();
          }
        });
      } else if (source == ImageSource.gallery) {
        await Permission.photos.isDenied.then((value) {
          if (value) {
            Permission.photos.request();
          }
        });
      }

      final file = await ImagePicker().pickImage(source: source);
      if (context.mounted) {
        if (file != null) {
          context.read<EditProfileBloc>().add(
                EditProfileChangePhotoEvent(
                  File(file.path),
                ),
              );
          Navigator.of(context).pop();
        }
      }
    } on Exception catch (e) {
      debugPrint('image pick error $e');
      // if (Platform.isIOS) {
      //   if (source == ImageSource.gallery) {
      //     if (await Permission.photos.status.isDenied) {
      //       await openAppSettings();
      //     }
      //   } else if (source == ImageSource.camera) {
      //     if (await Permission.camera.status.isDenied) {
      //       await openAppSettings();
      //     }
      //   }
      // }
    }
  }
}
