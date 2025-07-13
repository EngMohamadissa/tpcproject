import 'package:tcp/core/util/const.dart';
import 'package:tcp/core/util/styles.dart';
import 'package:flutter/material.dart';

class AppareWidget extends StatelessWidget {
  const AppareWidget({
    super.key,
    required this.title,
    required this.automaticallyImplyLeading,
    this.leading,
    this.actions,
  });

  final String title;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Palette.primary,
      title: Center(
        child: Text(
          title,
          style: Styles.textStyle18.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
