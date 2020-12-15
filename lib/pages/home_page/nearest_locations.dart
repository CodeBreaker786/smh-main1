import 'package:flutter/material.dart';
import 'package:sarasotaapp/model/locationitem.dart';
import 'package:sarasotaapp/navigation.dart';
import 'package:sarasotaapp/pages/locations/locationdetails.dart';

class NearestLocations extends StatefulWidget {
  
  List<LocationItem> cardsData = List();
     NearestLocations({this.cardsData});

  @override
  _NearestLocationsState createState() => _NearestLocationsState();
}

class _NearestLocationsState extends State<NearestLocations> {
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
             mainAxisSpacing: 12,
             children: [
                  ...widget.cardsData.map(
                                    (e) => _buildListCard(
                                        path: e.image, 
                                        title: e.title,
                                        callBack: () {
                                           Navigation.open(
                    context,
                    LocationDetails(
                      info:  e,
                      distance: e.distance != null
                          ? '${e.distance} mi'
                          : '',
                      latitude: e.latitude,
                      longitude: e.longitude,
                      address: e.mapAddress,
                      //address:list[i].address,
                    ),
                  );
                                        }),
                                  )
             ],
           ),
         ),
       );
       
      
     }
      _buildListCard({String title, String path, Function callBack}) {
    return InkWell(
      onTap: () {
        callBack();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Container(
               width: MediaQuery.of(context).size.width * .5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
           
                height: MediaQuery.of(context).size.height * .15,
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
                  title,
                  //overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
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
        ),
      ),
    );
  }
}
   
 