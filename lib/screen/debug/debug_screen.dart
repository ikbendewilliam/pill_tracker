// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get_it/get_it.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:pill_tracker/database/pill_tracker_database.dart';
import 'package:pill_tracker/navigator/main_navigator.dart';
import 'package:pill_tracker/util/keys.dart';
import 'package:pill_tracker/viewmodel/debug/debug_viewmodel.dart';
import 'package:pill_tracker/viewmodel/global/global_viewmodel.dart';
import 'package:pill_tracker/widget/debug/debug_row_item.dart';
import 'package:pill_tracker/widget/debug/debug_row_title.dart';
import 'package:pill_tracker/widget/debug/debug_switch_row_item.dart';
import 'package:pill_tracker/widget/debug/select_language_dialog.dart';
import 'package:pill_tracker/widget/provider/provider_widget.dart';

class DebugScreen extends StatefulWidget {
  static const String routeName = 'debug';

  const DebugScreen({
    Key? key,
  }) : super(key: key);

  @override
  DebugScreenState createState() => DebugScreenState();
}

@visibleForTesting
class DebugScreenState extends State<DebugScreen> implements DebugNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DebugViewModel>(
      consumerWithThemeAndLocalization: (context, viewModel, child, _, localization) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(localization.settingsTitle),
        ),
        body: ResponsiveWidget(
          builder: (context, info) => ListView(
            children: [
              DebugRowTitle(title: localization.debugAnimationsTitle),
              DebugRowSwitchItem(
                key: Keys.debugSlowAnimations,
                title: localization.debugSlowAnimations,
                value: viewModel.slowAnimationsEnabled,
                onChanged: viewModel.onSlowAnimationsChanged,
              ),
              DebugRowTitle(title: localization.debugThemeTitle),
              DebugRowItem(
                key: Keys.debugTargetPlatform,
                title: localization.debugTargetPlatformTitle,
                subTitle: localization.debugTargetPlatformSubtitle(localization.getTranslation(Provider.of<GlobalViewModel>(context).getCurrentPlatform())),
                onClick: viewModel.onTargetPlatformClicked,
              ),
              DebugRowTitle(title: localization.debugLocaleTitle),
              DebugRowItem(
                key: Keys.debugSelectLanguage,
                title: localization.debugLocaleSelector,
                subTitle: localization.debugLocaleCurrentLanguage(Provider.of<GlobalViewModel>(context).getCurrentLanguage()),
                onClick: viewModel.onSelectLanguageClicked,
              ),
              DebugRowSwitchItem(
                key: Keys.debugShowTranslations,
                title: localization.debugShowTranslations,
                value: Provider.of<GlobalViewModel>(context, listen: false).showsTranslationKeys,
                onChanged: (_) => Provider.of<GlobalViewModel>(context, listen: false).toggleTranslationKeys(),
              ),
              DebugRowTitle(title: localization.debugLicensesTitle),
              DebugRowItem(
                key: Keys.debugLicense,
                title: localization.debugLicensesGoTo,
                onClick: viewModel.onLicensesClicked,
              ),
              DebugRowTitle(title: localization.debugDatabase),
              DebugRowItem(
                key: Keys.debugDatabase,
                title: localization.debugViewDatabase,
                onClick: goToDatabase,
              ),
            ],
          ),
        ),
      ),
      create: () => GetIt.I()..init(this),
    );
  }

  @override
  void goToTargetPlatformSelector() => MainNavigatorWidget.of(context).goToDebugPlatformSelector();

  @override
  void goToLicenses() => MainNavigatorWidget.of(context).goToLicense();

  @override
  void goToSelectLanguage() => MainNavigatorWidget.of(context).showCustomDialog<void>(
        builder: (context) => SelectLanguageDialog(
          goBack: () => MainNavigatorWidget.of(context).closeDialog(),
        ),
      );

  void goToDatabase() {
    final db = GetIt.I<PTDatabase>();
    MainNavigatorWidget.of(context).goToDatabase(db);
  }
}
