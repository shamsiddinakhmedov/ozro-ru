import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';

class SuperAdminWidget extends StatelessWidget {
  const SuperAdminWidget(
      {super.key, required this.title, required this.onSwitch, required this.isSwitched, required this.onInfoTap});
  final String title;
  final ValueChanged<bool> onSwitch;
  final bool isSwitched;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: () {
        onSwitch(!isSwitched);
      },
      leading: CircleAvatar(
        backgroundColor: context.color.disabled,
        child: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: onInfoTap,
        ),
      ),
      title: Text(title),
      trailing: CupertinoSwitch(
        onChanged: onSwitch,
        value: isSwitched,
      ));
}
