import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/widgets/get_lives.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).storeTitle),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: insetsDefault,
            child: Column(
              children: [
                GetLives(Strings.of(context).storeBuyLives),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
