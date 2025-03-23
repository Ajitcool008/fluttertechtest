import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../localization/app_localizations.dart';
import '../../../ui/common/ui_helpers.dart';
import '../../../ui/widgets/error_widget.dart';
import '../../../ui/widgets/loading_widget.dart';
import 'post_details_viewmodel.dart';

class PostDetailsView extends StatelessWidget {
  final int postId;

  const PostDetailsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostDetailsViewModel>.reactive(
      viewModelBuilder: () => PostDetailsViewModel(),
      onViewModelReady: (model) => model.loadPostDetails(postId),
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).translate('post_details_title'),
              ),
            ),
            body: Builder(
              builder: (context) {
                if (model.isBusy) {
                  return const LoadingWidget();
                } else if (model.hasError) {
                  return ErrorMessageWidget(
                    message: model.errorMessage,
                    onRetry: () => model.loadPostDetails(postId),
                  );
                } else if (model.post != null) {
                  return SingleChildScrollView(
                    padding: paddingMedium,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.post!.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        verticalSpaceMedium,
                        Text(
                          model.post!.body,
                          style: const TextStyle(fontSize: 16),
                        ),
                        verticalSpaceLarge,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => model.toggleSavePost(),
                              icon: Icon(
                                model.post!.isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                              ),
                              label: Text(
                                model.post!.isSaved
                                    ? AppLocalizations.of(
                                      context,
                                    ).translate('unsave_button')
                                    : AppLocalizations.of(
                                      context,
                                    ).translate('save_button'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    model.post!.isSaved
                                        ? Colors.red
                                        : Colors.blue,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => model.navigateToComments(),
                              icon: const Icon(Icons.comment),
                              label: Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('view_comments_button'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).translate('post_not_found'),
                    ),
                  );
                }
              },
            ),
          ),
    );
  }
}
