import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  DefaultLayout(
      {Key? key, this.backgroundColor, required this.child, this.title, this.bottomNavigationBar,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            title!,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}