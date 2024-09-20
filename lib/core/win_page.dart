import 'dart:math';
import 'package:flutter/material.dart';
import '../product/color/color_items.dart';
import '../product/lang/langue_item.dart';
import '../product/utils/constants.dart';

class CustomShowDialog extends StatefulWidget {
  const CustomShowDialog({super.key});

  @override
  State<CustomShowDialog> createState() => _CustomShowDialogState();
}

class _CustomShowDialogState extends State<CustomShowDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: ProjectPadding().buttonSymetirc,
        child: Container(
          decoration: _boxDecoration(),
          child: _headOrTail(context),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  ElevatedButton _headOrTail(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (RandomInt().rastgeleSayi == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _AlertDialogHeadsTails(
              textUp: ProjectTexts().heads,
              imageAssets: ProjectAssets().heads,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => _AlertDialogHeadsTails(
              textUp: ProjectTexts().tails,
              imageAssets: ProjectAssets().tails,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ProjectColor().elevatedButton,
        shadowColor: ProjectColor().elevatedButton,
      ),
      child: Padding(
        padding: ProjectPadding().headsTailseAssetsSymmetric,
        child: Text(
          ProjectTexts().headsOrTails,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: ProjectCircular().circular20,
      color: ProjectColor().whiteARGB,
    );
  }
}

//------------------------------------------------------------------------------

class RandomInt {
  int rastgeleSayi = Random().nextInt(2);
}

class _AlertDialogHeadsTails extends StatelessWidget {
  const _AlertDialogHeadsTails({
    required this.textUp,
    required this.imageAssets,
  });

  final String textUp;
  final String imageAssets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPadding().showDiaologSymetric,
      child: AlertDialog(
        backgroundColor: ProjectColor().draweBG,
        alignment: Alignment.topCenter,
        title: Text(textUp, textAlign: TextAlign.center),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: ProjectColor().headsTailsColor,
              letterSpacing: ProjectNumbers().headsTailsLetterSpacing,
            ),
        content: Padding(
          padding: ProjectPadding().headsTailseAssetsSymmetric2X,
          child: Image.asset(
            imageAssets,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
