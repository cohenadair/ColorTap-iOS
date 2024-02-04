import 'package:flutter/material.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/widgets/get_lives.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store"),
      ),
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: insetsDefault,
            child: Column(
              children: [
                GetLives("BUY LIVES"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
