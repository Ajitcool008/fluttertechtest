import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';
import '../../localization/app_localizations.dart';
import '../common/app_colors.dart';

class SaveButtonWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onPressed;

  const SaveButtonWidget({
    super.key,
    required this.post,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(post.isSaved ? Icons.bookmark : Icons.bookmark_border),
      label: Text(
        post.isSaved
            ? AppLocalizations.of(context).translate('unsave_button')
            : AppLocalizations.of(context).translate('save_button'),
        style: const TextStyle(color: AppColors.buttonText),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: post.isSaved ? AppColors.error : AppColors.primary,
      ),
    );
  }
}
