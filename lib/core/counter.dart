import 'package:flutter/material.dart';
import '../product/color/color_items.dart';
import '../product/lang/langue_item.dart';
import '../product/utils/constants.dart';

class CustomCounter extends StatefulWidget {
  const CustomCounter({super.key});

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  int _countValue_1 = 0;
  int _countValue_2 = 0;

  void _counterUpdate(bool isIncrement) {
    if (isIncrement) {
      setState(() {
        _countValue_1 += 1;
      });
    } else {
      setState(() {
        _countValue_1 -= 1;
      });
      if (_countValue_1 < 0) {
        _countValue_1 = 0;
      }
    }
  }

  void _counterUpdate_2(bool isIncrement) {
    if (isIncrement) {
      setState(() {
        _countValue_2 += 1;
      });
    } else {
      setState(() {
        _countValue_2 -= 1;
      });
      if (_countValue_2 < 0) {
        _countValue_2 = 0;
      }
    }
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [_leftCounter(), _rightCounter()],
    );
  }

  Row _rightCounter() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _counterUpdate_2(false);
          },
          child: _CounterUpdateContainer(ProjectTexts().minus),
        ),
        _counterText_2(),
        InkWell(
          onTap: () {
            _counterUpdate_2(true);
          },
          child: _CounterUpdateContainer(
            ProjectTexts().plus,
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------

  Row _leftCounter() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _counterUpdate(false);
          },
          child: _CounterUpdateContainer(ProjectTexts().minus),
        ),
        _counterText(),
        InkWell(
          onTap: () {
            _counterUpdate(true);
          },
          child: _CounterUpdateContainer(
            ProjectTexts().plus,
          ),
        ),
      ],
    );
  }

  Padding _counterText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        _countValue_1.toString(),
        style: TextStyle(
          color: ProjectColor().headsTailsColor,
          fontSize: ProjectNumbers().appBarActionsIcons,
        ),
      ),
    );
  }

  Padding _counterText_2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        _countValue_2.toString(),
        style: TextStyle(
          color: ProjectColor().headsTailsColor,
          fontSize: ProjectNumbers().appBarActionsIcons,
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------

class _CounterUpdateContainer extends StatelessWidget {
  const _CounterUpdateContainer(this.minusPlus);

  final String minusPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: ProjectNumbers().counterSize,
      width: ProjectNumbers().counterSize,
      decoration: BoxDecoration(
        borderRadius: ProjectCircular().circular5,
        color: ProjectColor().whiteARGB,
      ),
      child: RepaintBoundary(
        child: Text(
          minusPlus,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ProjectColor().draweBG,
            fontSize: ProjectNumbers().conterTextSize,
          ),
        ),
      ),
    );
  }
}
