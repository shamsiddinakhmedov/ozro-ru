import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CustomPopUpMenuWidget extends StatefulWidget {
  const CustomPopUpMenuWidget({
    super.key,
    this.size = 48,
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  final double size;
  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<CustomPopUpMenuWidget> createState() => _CustomPopUpMenuWidgetState();
}

class _CustomPopUpMenuWidgetState extends State<CustomPopUpMenuWidget> {
  late CustomPopupMenuController popUpMenuController;

  @override
  void initState() {
    popUpMenuController = CustomPopupMenuController();
    super.initState();
  }

  @override
  void dispose() {
    debugLog('custom popup menu dispose');
    popUpMenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPopupMenu(
        controller: popUpMenuController,
        arrowColor: context.color.white,
        // verticalMargin: -150,
        position: PreferredPosition.bottom,
        menuBuilder: () => GestureDetector(
          onTap: popUpMenuController.hideMenu,
          child: SizedBox(
            width: context.kSize.width * 0.5,
            child: Ink(
              padding: AppUtils.kPaddingAll12,
              decoration: BoxDecoration(
                borderRadius: AppUtils.kBorderRadius12,
                color: context.color.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      popUpMenuController.hideMenu();
                      widget.onEdit();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          AppIcons.editUnderLine,
                          color: context.colorScheme.primary,
                        ),
                        AppUtils.kGap4,
                        Text(
                          'Редактировать',
                          style: context.textStyle.regularSubheadline,
                        ),
                      ],
                    ),
                  ),
                  AppUtils.kDividerWithPaddingVer12,
                  GestureDetector(
                    onTap: () {
                      popUpMenuController.hideMenu();
                      widget.onDelete();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          AppIcons.delete,
                          color: context.colorScheme.error,
                        ),
                        AppUtils.kGap4,
                        Text(
                          'Удалить',
                          style: context.textStyle.regularSubheadline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        pressType: PressType.singleClick,
        child: widget.child,
      );
}
