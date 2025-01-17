import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmPrivacyPolicyTextWidget extends StatelessWidget {
  const ConfirmPrivacyPolicyTextWidget({super.key});

  @override
  Widget build(BuildContext context) => RichText(
        textAlign: TextAlign.center,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: context.tr('by_clicking_continue'),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF708393),
          ),
          children: <TextSpan>[
            TextSpan(
              text: context.tr('privacy_policy'),
              style: TextStyle(
                fontSize: 13,
                color: context.colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    launchUrl(Uri.parse('https://www.freeprivacypolicy.com/live/1eb1b769-d433-4414-b131-7b06a41ac638')),
            ),
            const TextSpan(
              text: 'context.tr(by_clicking_continue_2)',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF708393),
              ),
            ),
          ],
        ),
      );
}
