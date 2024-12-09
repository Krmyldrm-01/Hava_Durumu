import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.flickr(
              leftDotColor: Colors.blue,
              rightDotColor: Colors.white,
              size: 50,
            ),
            //CircularProgressIndicator(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Lütfen bekleyiniz",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black12),
            ),
          ],
        ),
      ),
    );
  }
}
