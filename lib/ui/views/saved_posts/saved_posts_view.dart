import 'package:flutter/material.dart';
import 'package:flutter_tech_task/di/manual_locator.dart';
import 'package:stacked/stacked.dart';

import '../../../localization/app_localizations.dart';
import '../../../ui/widgets/empty_saved_posts_widget.dart';
import '../../../ui/widgets/error_widget.dart';
import '../../../ui/widgets/loading_widget.dart';
import '../../../ui/widgets/post_list_item.dart';
import 'saved_posts_viewmodel.dart';

class SavedPostsView extends StatelessWidget {
  const SavedPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedPostsViewModel>.reactive(
      viewModelBuilder:
          () => locator<SavedPostsViewModel>(), // Use the singleton
      disposeViewModel: false, // Don't dispose it
      fireOnViewModelReadyOnce:
          false, // Fire onModelReady every time the view is shown
      onViewModelReady: (model) => model.loadSavedPosts(),
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).translate('saved_posts_title'),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => model.loadSavedPosts(),
              child: Builder(
                builder: (context) {
                  if (model.isBusy) {
                    return const LoadingWidget();
                  } else if (model.hasError) {
                    return ErrorMessageWidget(
                      message: model.errorMessage,
                      onRetry: model.loadSavedPosts,
                    );
                  } else if (model.savedPosts.isEmpty) {
                    return const EmptySavedPostsWidget();
                  } else {
                    return ListView.builder(
                      itemCount: model.savedPosts.length,
                      itemBuilder: (context, index) {
                        final post = model.savedPosts[index];
                        return PostListItem(
                          post: post,
                          onTap: () => model.navigateToPostDetails(post.id),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
    );
  }
}
