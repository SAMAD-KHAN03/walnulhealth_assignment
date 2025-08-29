  import 'package:flutter/material.dart';

  class ShowCompleteDialogue extends StatelessWidget {
    final String title;
    final String message;
    final String buttonText;
    final VoidCallback? onPressed;

        const ShowCompleteDialogue({
          Key? key,
          this.title = 'Great Job!',
          this.message =
              'You\'ve completed your habit for today. Keep up the great work!',
          this.buttonText = 'Continue',
          this.onPressed,
        }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      );
    }

    // Static method for easy showing
    static void show(
      BuildContext context, {
      String title = 'Great Job!',
      String message =
          'You\'ve completed your habit for today. Keep up the great work!',
      String buttonText = 'Continue',
      VoidCallback? onPressed,
    }) {
      showDialog(
        context: context,
        builder: (context) => ShowCompleteDialogue(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        ),
      );
    }
  }
