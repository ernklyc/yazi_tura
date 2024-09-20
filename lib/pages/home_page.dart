import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_bar_button_link.dart';
import '../core/counter.dart';
import '../core/flip_card.dart';
import '../core/win_page.dart';
import '../product/color/color_items.dart';
import '../product/lang/langue_item.dart';
import '../product/utils/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor().bg,
      appBar: _appBar(context),
      body: const Column(
        children: [
          Expanded(child: Spacer()),
          Expanded(flex: 4, child: FlipCoin()),
          Expanded(flex: 1, child: CustomCounter()),
          Expanded(flex: 3, child: CustomShowDialog()),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------

  Text _appBarTitle(BuildContext context) {
    return Text(
      ProjectTexts().appBarTitle,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: ProjectNumbers().headsTailsLetterSpacing,
            color: ProjectColor().whiteARGB,
          ),
    );
  }

  //----------------------------------------------------------------------------

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: AppBarButtonLink(
        linkUrl: ProjectAssets().web,
        icon: FontAwesomeIcons.circleInfo,
      ),
      actions: [
        AppBarButtonLink(
          linkUrl: ProjectAssets().goglePlay,
          icon: FontAwesomeIcons.googlePlay,
        )
      ],
      centerTitle: true,
      title: _appBarTitle(context),
    );
  }
}
