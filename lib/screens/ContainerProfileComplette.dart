import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/colors.dart';
import 'ProfileScreen.dart';

class ContainerUncompletteProfille extends StatelessWidget {
  const ContainerUncompletteProfille({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(appStore.translate('lbl_complt_profile'),
                textAlign: TextAlign.center,
                style:
                    primaryTextStyle().copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [colorPrimary, colorSecondary]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  appStore.translate('lbl_click'),
                  style: primaryTextStyle(color: Colors.white),
                ),
              ),
            ).onTap(() {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            }),
          ],
        ),
      ),
    );
  }
}
