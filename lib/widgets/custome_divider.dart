import 'package:flutter/material.dart';

class CustomDivider extends PopupMenuEntry<Null> {
  /// Creates a horizontal divider for a popup menu.
  ///
  /// By default, the divider has a height of 16 logical pixels.
  const CustomDivider(this.height);

  /// The height of the divider entry.
  ///
  /// Defaults to 16 pixels.
  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  _CustomDividerState createState() => _CustomDividerState();
}

class _CustomDividerState extends State<CustomDivider> {
  @override
  Widget build(BuildContext context) => Divider(height: widget.height,color: Colors.white.withOpacity(0.4),);
}