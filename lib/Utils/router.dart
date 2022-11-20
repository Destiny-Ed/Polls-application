import 'package:flutter/cupertino.dart';

nextPage(BuildContext context, Widget page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

nextPageOnly(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(context,
      CupertinoPageRoute(builder: (context) => page), (route) => false);
}
