import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommentEmpty extends StatelessWidget {
  const CommentEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage(
                //         'assets/images/nonoti.jpg'))
                ),
            child: Lottie.asset('assets/lottie/empty_purple.json'),
          ),
        ),
        const SizedBox(
          height: 0,
        ),
        Text(
          "Comments not found",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
