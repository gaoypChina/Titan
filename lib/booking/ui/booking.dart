import 'package:flutter/material.dart';
import 'package:myecl/booking/ui/top_bar.dart';

class BookingTemplate extends StatelessWidget {
  final Widget child;
  const BookingTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [const TopBar(), Expanded(child: child)],
          ),
        ),
      ),
    );
  }
}
