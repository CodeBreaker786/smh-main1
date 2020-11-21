import 'package:flutter/material.dart';

class NearestLocations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearest Locations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _buildListCard(path: 'assets/images/heart.jpg'),
            _buildListCard(path: 'assets/images/i21.jpeg'),
            _buildListCard(path: 'assets/images/heart.jpg'),
            _buildListCard(path: 'assets/images/heart.jpg'),
            _buildListCard(path: 'assets/images/heart.jpg'),
            _buildListCard(path: 'assets/images/heart.jpg'),
            _buildListCard(path: 'assets/images/heart.jpg'),
          ],
        ),
      ),
    );
  }

  _buildListCard({String title, String path, Function callBack}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              'Hospital Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              'Sarasota , Florida',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
