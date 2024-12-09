
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onpressed;
  final String buttonText;
  const SubmitButton({
    super.key,
    required this.onpressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0).copyWith(top: 0),
      child: SizedBox(
        height: 50,
        width: double.infinity, // Set width to take up the entire screen width
        child: ElevatedButton(
          onPressed: () => onpressed(),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.primaryColor,
              // backgroundColor: const Color.fromARGB(255, 69, 160, 72),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10)) // Set the button's background color to green
              ),
          child: Row(
            children: [
              Text(buttonText,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato', // Set the text color to white
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const Spacer(),
              SizedBox(
                height: 20,
                child: Lottie.asset(
                  'assets/lottie/right.json',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
