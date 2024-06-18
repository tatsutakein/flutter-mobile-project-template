part of 'package:flutter_app/router/provider/router.dart';

const settingShellBranch = TypedStatefulShellBranch<SettingShellBranch>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<SettingPageRoute>(
      path: SettingPageRoute.path,
      routes: [
        TypedGoRoute<LicensePageRoute>(
          path: LicensePageRoute.path,
        ),
      ],
    ),
  ],
);

class SettingShellBranch extends StatefulShellBranchData {
  const SettingShellBranch();
}

final class SettingNavigatorImpl implements SettingNavigator {
  const SettingNavigatorImpl();

  @override
  void goLicensePage(BuildContext context) {
    const LicensePageRoute().go(context);
  }
}

class SettingPageRoute extends GoRouteData {
  const SettingPageRoute();

  static const path = '/setting';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProviderScope(
      overrides: [
        settingNavigatorProvider.overrideWithValue(
          const SettingNavigatorImpl(),
        ),
      ],
      child: const SettingPage(),
    );
  }
}

class LicensePageRoute extends GoRouteData {
  const LicensePageRoute();

  static const path = 'license';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LicensePage(
      applicationIcon: CommonAssets.yumemiLogo.image(height: 100, width: 100),
    );
  }
}
