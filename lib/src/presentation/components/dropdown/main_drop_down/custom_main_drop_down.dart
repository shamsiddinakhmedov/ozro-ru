import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/extension/null_define_extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CustomMainDropdown<T> extends StatefulWidget {
  const CustomMainDropdown({
    super.key,
    this.hideIcon = false,
    required this.items,
    this.dropdownStyle,
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    this.validator,
    this.hinText,
    this.hintStyle,
    required this.initialText,
    this.prefixIcon,
    this.selectedItemText,
  });

  /// the child widget for the button, this will be ignored if text is supplied
  final String initialText;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T, int)? onChange;

  /// list of DropdownItems
  final List<DropdownItem<T>> items;
  final DropdownStyle? dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final DropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool hideIcon;
  final String Function()? validator;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  /// hint text
  final String? hinText;

  /// hint style
  final TextStyle? hintStyle;

  /// prefix icon
  final Widget? prefixIcon;

  /// selectedItemText
  final String? selectedItemText;

  @override
  State<CustomMainDropdown> createState() => _CustomMainDropdownState<T>();
}

class _CustomMainDropdownState<T> extends State<CustomMainDropdown<T>> with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.dropdownButtonStyle;
    final text = (widget.selectedItemText !=null) ? widget.selectedItemText! : widget.initialText;
    final Color? textColor = (widget.selectedItemText ?? '').isEmpty ? context.color.midGrey4 : null;
    // link the overlay to the button
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: style.width,
        height: style.height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: style.padding,
            backgroundColor: style.backgroundColor,
            elevation: style.elevation,
            foregroundColor: style.foregroundColor,
            shape: style.shape,
            side: BorderSide(
              color: style.borderColor ?? Colors.transparent,
              width: 2,
            ),
            alignment: Alignment.centerLeft,
          ),
          onPressed: _toggleDropdown,
          child: Row(
            mainAxisAlignment: style.mainAxisAlignment ?? MainAxisAlignment.start,
            textDirection: widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (_currentIndex == -1) ...[
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  AppUtils.kGap2,
                ],
                Text(
                  text,
                  style: context.textStyle.regularSubheadline.copyWith(color: textColor),
                ),
              ] else ...[
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  AppUtils.kGap2,
                ],
                if (widget.items.isNotEmpty) ...[
                  Text(
                    text,
                    style: context.textStyle.regularSubheadline.copyWith(color: textColor),
                  ),
                ] else ...[
                  DropdownItem(
                    text: widget.hinText,
                    value: widget.hinText,
                    index: 0,
                  ),
                ]
              ],
              if (!widget.hideIcon)
                RotationTransition(
                  turns: _rotateAnimation,
                  child: widget.icon,
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle?.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: widget.dropdownStyle?.offset ?? Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle?.elevation ?? 12,
                    shadowColor: const Color(0xFF5B6871).withOpacity(.20),
                    borderRadius: widget.dropdownStyle?.borderRadius ?? BorderRadius.zero,
                    color: widget.dropdownStyle?.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle?.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height - topOffset - 15,
                            ),
                        child: ListView(
                          padding: widget.dropdownStyle?.padding ?? EdgeInsets.zero,
                          shrinkWrap: true,
                          children: widget.items
                              .asMap()
                              .entries
                              .map(
                                (item) => InkWell(
                                  borderRadius: BorderRadius.only(
                                    topLeft: (item.key == 0)
                                        ? widget.dropdownStyle?.borderRadius?.topLeft ?? AppUtils.kRadius6
                                        : Radius.zero,
                                    topRight: (item.key == 0)
                                        ? widget.dropdownStyle?.borderRadius?.topRight ?? AppUtils.kRadius6
                                        : Radius.zero,
                                    bottomLeft: (item.key == widget.items.length - 1)
                                        ? widget.dropdownStyle?.borderRadius?.bottomLeft ?? AppUtils.kRadius6
                                        : Radius.zero,
                                    bottomRight: (item.key == widget.items.length - 1)
                                        ? widget.dropdownStyle?.borderRadius?.bottomRight ?? AppUtils.kRadius6
                                        : Radius.zero,
                                  ),
                                  onTap: () {
                                    setState(() => _currentIndex = item.key);
                                    widget.onChange?.call(item.value.value, item.key);
                                    _toggleDropdown();
                                  },
                                  child: item.value.copyWith(
                                    selectedItemText: widget.selectedItemText ?? '',
                                    // (_currentIndex >= 0 ? widget.items[_currentIndex].text : ''),
                                    listLengthForDivider: widget.items.length,
                                    index: item.key,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      if (_overlayEntry.mounted && _overlayEntry.isNotNull) {
        _overlayEntry.remove();
      }
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() => _isOpen = true);
      await _animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  const DropdownItem({
    super.key,
    required this.value,
    this.text,
    this.selectedItemText,
    this.index,
    this.listLengthForDivider = 0,
    this.isVisible = true,
    this.isValueSelected,
  });

  final T value;
  final String? text;
  final String? selectedItemText;
  final int? index;
  final int listLengthForDivider;
  final bool isVisible;
  final bool? isValueSelected;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = isValueSelected ?? selectedItemText == text;
    return isVisible
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text ?? '',
                      style: context.textStyle.regularSubheadline,
                    ),
                    if (isSelected) Icon(Icons.check, size: 24, color: context.colorScheme.primary),
                  ],
                ),
              ),
              if ((index ?? 0) < listLengthForDivider - 1) AppUtils.kDivider,
            ],
          )
        : AppUtils.kGap;
  }
}

extension DropdownItemExtension on DropdownItem {
  DropdownItem copyWith({
    Type? type,
    String? text,
    String? selectedItemText,
    int? index,
    int? listLengthForDivider,
    bool? isVisible,
  }) =>
      DropdownItem(
        value: value ?? value,
        text: text ?? this.text,
        selectedItemText: selectedItemText ?? this.selectedItemText,
        index: index ?? this.index,
        listLengthForDivider: listLengthForDivider ?? this.listLengthForDivider,
        isVisible: isVisible ?? this.isVisible,
      );
}

class DropdownButtonStyle {
  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
    this.borderColor,
    this.foregroundColor,
  });

  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;
  final Color? borderColor;
  final Color? foregroundColor;
}

class DropdownStyle {
  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });

  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;
}
