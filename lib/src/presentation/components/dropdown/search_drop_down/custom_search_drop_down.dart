import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/typedef/app_typedef.dart';

const TextStyle mainTextStyle = TextStyle(
  fontSize: 13,
  color: Colors.black,
);

class CustomSearchDropDown<T> extends StatefulWidget {
  const CustomSearchDropDown({
    super.key,
    this.hideIcon = false,
    required this.items,
    this.dropdownStyle,
    this.dropdownButtonStyle = const SearchDropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    this.validator,
    this.hinText,
    this.hintStyle,
    required this.initialText,
    this.isInitialTextGrey = true,
    this.selectedItemText,
    this.isSearchable = false,
    this.controller,
    this.prefixIcon,
    this.onClear,
    this.isTextFieldActive,
  });

  /// the child widget for the button, this will be ignored if text is supplied
  final String initialText;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T, int)? onChange;

  /// list of DropdownItems
  final List<SearchDropdownItem<T>> items;
  final SearchDropdownStyle? dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final SearchDropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool hideIcon;
  final Validator? validator;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  /// hint text
  final String? hinText;

  final TextStyle? hintStyle;

  /// initial Color text
  final bool isInitialTextGrey;

  /// selected item text
  final String? selectedItemText;

  /// isSearchable defaults to false
  final bool isSearchable;

  /// controller
  final TextEditingController? controller;

  final Widget? prefixIcon;

  final void Function()? onClear;

  /// when textField is active
  final ValueChanged<bool>? isTextFieldActive;

  @override
  State<CustomSearchDropDown> createState() => _CustomSearchDropDownState<T>();
}

class _CustomSearchDropDownState<T> extends State<CustomSearchDropDown<T>> with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode = FocusNode();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    _focusNode.addListener(() {
      setState(() {});
      if (widget.isTextFieldActive != null) {
        widget.isTextFieldActive!.call(_focusNode.hasFocus);
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Column(
            children: [
              if (_currentIndex == -1) ...[
                _SearchTextField(
                  focusNode: _focusNode,
                  controller: widget.controller ?? _searchController,
                  toggleDropdown: _toggleDropdown,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.onClear != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            debugPrint('----> onClear');
                            widget.controller?.clear();
                            _searchController.clear();
                            widget.onClear!();
                          },
                        )
                      : null,
                  hintText: widget.initialText,
                  validator: widget.validator,
                ),
              ] else ...[
                // if (widget.items.isNotEmpty) ...[
                _SearchTextField(
                  focusNode: _focusNode,
                  controller: widget.controller ?? _searchController,
                  toggleDropdown: _toggleDropdown,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.onClear != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            debugPrint('----> onClear');
                            widget.controller?.clear();
                            _searchController.clear();
                            widget.onClear!();
                          },
                        )
                      : null,
                  hintText: widget.initialText,
                  validator: widget.validator,
                ),
                // ] else ...[
                //   SearchDropdownItem(
                //     text: widget.hinText,
                //     value: widget.hinText,
                //     index: 0,
                //   ),
                // ]
              ],
            ],
          ),
        ),
      );

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
                        child: ToggleDropDownBuilder<T>(
                          toggleDropdown: _toggleDropdown,
                          searchController: widget.controller ?? _searchController,
                          dropdownButtonStyle: widget.dropdownButtonStyle,
                          selectedItemText: widget.selectedItemText ?? '',
                          dropdownStyle: widget.dropdownStyle,
                          context1: context,
                          onChange: (value, index, currentIndex, ctrText) {
                            setState(() {
                              _currentIndex = currentIndex;
                              // _searchController = TextEditingController(text: ctrText);
                            });
                            if (widget.onChange != null) {
                              widget.onChange!(value, index);
                            }
                            _focusNode.unfocus();
                          },
                          items: widget.items,
                          currentIndex: _currentIndex,
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

  Future<void> _toggleDropdown({bool close = false, String? searchText}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
        if (widget.isTextFieldActive != null) {
          widget.isTextFieldActive!(false);
        }
      });
      _focusNode.unfocus();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() {
        _isOpen = true;
        if (widget.isTextFieldActive != null) {
          widget.isTextFieldActive!(true);
        }
      });
      await _animationController.forward();
    }
  }
}

class ToggleDropDownBuilder<T> extends StatefulWidget {
  const ToggleDropDownBuilder({
    super.key,
    this.items = const [],
    this.dropdownStyle,
    this.dropdownButtonStyle,
    required this.toggleDropdown,
    this.onChange,
    this.selectedItemText = '',
    this.currentIndex = 0,
    required this.searchController,
    required this.context1,
  });

  final List<SearchDropdownItem<T>> items;
  final SearchDropdownStyle? dropdownStyle;
  final SearchDropdownButtonStyle? dropdownButtonStyle;
  final Future<void> Function() toggleDropdown;
  final void Function(
    T value,
    int index,
    int currentIndex,
    String controllerText,
  )? onChange;
  final String selectedItemText;
  final int currentIndex;
  final TextEditingController searchController;
  final BuildContext context1;

  @override
  State<ToggleDropDownBuilder<T>> createState() => _ToggleDropDownBuilderState();
}

class _ToggleDropDownBuilderState<T> extends State<ToggleDropDownBuilder<T>> {
  late List<SearchDropdownItem<T>> _items;
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    if (!mounted) return;
    _items = [...widget.items];
    _textEditingController = widget.searchController;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!mounted) return;
    _textEditingController.addListener(() {
      _search(_textEditingController.text);
    });
    super.didChangeDependencies();
  }

  void _search(String text) {
    final items = widget.items;
    final result = items.where((element) {
      final name =
          element.text?.replaceAll(' ', '').replaceAll(RegExp(r'[^\p{L}\s0-9]+', unicode: true), '').toLowerCase();
      final input = text.replaceAll(' ', '').replaceAll(RegExp(r'[^\p{L}\s0-9]+', unicode: true), '').toLowerCase();

        return (name ?? '').contains(input);

    }).toList();
    if (mounted) {
      setState(() {
        _items = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: widget.dropdownStyle?.padding ?? EdgeInsets.zero,
        shrinkWrap: true,
        children: _items
            .asMap()
            .entries
            .map(
              (item) => InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: (item.key == 0)
                      ? widget.dropdownStyle?.borderRadius?.topLeft ?? const Radius.circular(6)
                      : Radius.zero,
                  topRight: (item.key == 0)
                      ? widget.dropdownStyle?.borderRadius?.topRight ?? const Radius.circular(6)
                      : Radius.zero,
                  bottomLeft: (item.key == _items.length - 1)
                      ? widget.dropdownStyle?.borderRadius?.bottomLeft ?? const Radius.circular(6)
                      : Radius.zero,
                  bottomRight: (item.key == _items.length - 1)
                      ? widget.dropdownStyle?.borderRadius?.bottomRight ?? const Radius.circular(6)
                      : Radius.zero,
                ),
                onTap: () {
                  final int index = widget.items.indexWhere((element) => element.text == item.value.text);
                  widget.onChange!(
                    item.value.value,
                    index,
                    index,
                    item.value.text ?? '',
                  );

                  widget.toggleDropdown();
                },
                child: item.value.copyWith(
                  selectedItemText: widget.selectedItemText,
                  listLengthForDivider: _items.length,
                  index: item.key,
                ),
              ),
            )
            .toList(),
      );
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class SearchDropdownItem<T> extends StatelessWidget {
  const SearchDropdownItem({
    super.key,
    required this.value,
    this.text,
    this.selectedItemText,
    this.index,
    this.listLengthForDivider = 0,
    this.isVisible = true,
    this.iconColor = Colors.green,
  });

  final T value;
  final String? text;
  final String? selectedItemText;
  final int? index;
  final int listLengthForDivider;
  final bool isVisible;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedItemText == text;
    return isVisible
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text ?? '',
                      style: mainTextStyle,
                    ),
                    if (isSelected) Icon(Icons.check, size: 24, color: context.colorScheme.primary),
                  ],
                ),
              ),
              if ((index ?? 0) < listLengthForDivider - 1) const Divider(),
            ],
          )
        : const SizedBox();
  }
}

extension SearChDropdownItemExtension on SearchDropdownItem {
  SearchDropdownItem copyWith({
    Type? type,
    String? text,
    String? selectedItemText,
    int? index,
    int? listLengthForDivider,
    bool? isVisible,
  }) =>
      SearchDropdownItem(
        value: value ?? value,
        text: text ?? this.text,
        selectedItemText: selectedItemText ?? this.selectedItemText,
        index: index ?? this.index,
        listLengthForDivider: listLengthForDivider ?? this.listLengthForDivider,
        isVisible: isVisible ?? this.isVisible,
      );
}

class SearchDropdownButtonStyle {
  const SearchDropdownButtonStyle({
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

class SearchDropdownStyle {
  const SearchDropdownStyle({
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

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.focusNode,
    required this.controller,
    required this.toggleDropdown,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    required this.validator,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final VoidCallback toggleDropdown;
  final Widget? prefixIcon;
  final String? hintText;
  final Validator? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) => TextFormField(
        focusNode: focusNode,
        validator: validator,
        style: const TextStyle(
          fontSize: 13,
          height: 16 / 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: focusNode.hasFocus ? context.color.white : context.color.disabled,
          prefixIcon: prefixIcon,
          hintText: hintText,
        ),
        controller: controller,
        onTap: toggleDropdown,
        onChanged: (value) {},
      );
}
