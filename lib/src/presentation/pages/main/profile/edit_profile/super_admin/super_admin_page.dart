import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/components/dialogs/custom_dialog.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/super_admin_widget.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  String token = '';

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Future<void> _getToken() async {
    token = await FirebaseMessaging.instance.getToken() ?? '';
    setState(() {});
  }

  Widget divider() => Divider(
        indent: 28,
        endIndent: 16,
        color: context.colorScheme.primary,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.color.white,
        appBar: AppBar(
          title: const Text('SUPER ADMIN'),
          centerTitle: true,
          shadowColor: context.color.black.withOpacity(0.15),
          elevation: 4,
          actions: [
            CircleAvatar(
              backgroundColor: context.color.disabled,
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: context.color.midGrey5,
                ),
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    title: "E'tibor bering",
                    content: 'Agarda Chuck yoqilsa/o\'chirilsa iltimos dasturni qayta ishga tushiring!',
                    defaultActionText: 'OK',
                  );
                },
              ),
            )
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                AppUtils.kGap12,
                SuperAdminWidget(
                  title: 'Chuck',
                  onSwitch: (value) async {
                    if (value) {
                      await Permission.notification.isDenied.then((value) {
                        if (value) {
                          Permission.notification.request();
                        }
                      });
                    }
                    await localSource.setEnableChuck(enableChuck: value).then((value) => setState(() {}));
                  },
                  isSwitched: localSource.enableChuck,
                  onInfoTap: () {
                    showCustomDialog(
                        context: context,
                        title: 'Chuck',
                        content: 'Chuck yoqilsa, request api lar haqida ma\'lumot beriladi',
                        defaultActionText: 'OK');
                  },
                ),
                divider(),
                Padding(
                  padding: AppUtils.kPaddingHorizontal16,
                  child: Material(
                    borderRadius: AppUtils.kBorderRadius12,
                    color: context.color.disabled,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showCustomDialog(
                              context: context,
                              title: 'FCM TOKEN',
                              content: 'Firebase Messaging Token',
                              defaultActionText: 'OK',
                            );
                          },
                          icon: const Icon(
                            Icons.info_outline,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: token),
                            fillColor: context.color.disabled,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.copy_outlined),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: token));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
