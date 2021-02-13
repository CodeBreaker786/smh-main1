import 'package:flutter/material.dart';
import 'package:sarasotaapp/pages/home_page/menu.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: UALabel(
            text: 'Favorites',
            size: UATheme.headingSize(),
          ),
        ),
        drawer: Menu(),
        body: Center(
          child: Image.asset('assets/images/bookmark.png'),
        ));
  }

  line() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}
