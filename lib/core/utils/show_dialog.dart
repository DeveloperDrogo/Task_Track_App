
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';

void showAwesomeDialog({
  required BuildContext context,
  required String type,
  required String title,
  required String desc,
  required String successButtonText,
  required String failedButtonText,
  required VoidCallback okButtonPress,
  required VoidCallback cancelButtonPress,
}) {
  final String lottie = type == 'success'
      ? 'assets/lottie/success.json'
      : type == 'failure'
          ? 'assets/lottie/failure.json'
          : type == 'exit'
              ? 'assets/lottie/exit.json'
              :type =='event'?
              'assets/lottie/calendar.json':
               'assets/lottie/question.json';
  AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Lottie.asset(
                lottie,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              desc,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 15,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: okButtonPress,
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        backgroundColor: AppPallete.successColor),
                    child: Text(
                      successButtonText,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                ),
                const SizedBox(width: 0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: cancelButtonPress,
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      backgroundColor: AppPallete.buttonErrorColor,
                    ),
                    child: Text(
                      failedButtonText,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )).show();
}
