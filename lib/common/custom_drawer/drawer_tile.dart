import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int page;

  DrawerTile(
      {@required this.iconData, @required this.title, @required this.page});

  @override
  Widget build(BuildContext context) {
    final choicePage = Provider.of<PageManager>(context).page;
    final Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () {
        Provider.of<PageManager>(context, listen: false).setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: (choicePage == page) ? primaryColor : Colors.grey,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: (choicePage == page) ? primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}