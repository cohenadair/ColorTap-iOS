import 'package:flutter/material.dart';
import 'package:mobile/utils/dimens.dart';

class TitleMediumText extends StatelessWidget {
  final String text;

  const TitleMediumText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}

class TitleMediumBoldText extends StatelessWidget {
  final String text;

  const TitleMediumBoldText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: fontWeightBold),
    );
  }
}

class PaddedColonText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: insetsHorizontalSmall,
      child: TitleMediumText(":"),
    );
  }
}
