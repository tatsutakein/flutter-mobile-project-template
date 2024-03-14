import 'package:flutter/material.dart';

abstract interface class HomeNavigator {
  void goDebugModePage(BuildContext context);
  void goWebView(BuildContext context);
  void goGithubRepositoryDetail(BuildContext context, String repositoryName);
}
