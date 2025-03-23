import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../../localization/app_localizations.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  final Function onTap;

  const PostListItem({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpaceSmall,
            Text(
              post.body,
              style: const TextStyle(color: AppColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpaceMedium,
            if (post.isSaved)
              Chip(
                backgroundColor: AppColors.saved.withOpacity(0.2),
                label: Text(
                  AppLocalizations.of(context).translate('saved_posts_title'),
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 12,
                  ),
                ),
              ),
            const Divider(
              thickness: 1,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}