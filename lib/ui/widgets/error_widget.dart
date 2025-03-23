import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorMessageWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 60,
          ),
          verticalSpaceMedium,
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          verticalSpaceLarge,
          ElevatedButton(
            onPressed: onRetry,
            child: Text(
              AppLocalizations.of(context).translate('try_again'),
              style: const TextStyle(color: AppColors.buttonText),
            ),
          ),
        ],
      ),
    );
  }
}