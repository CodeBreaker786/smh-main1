import 'package:flutter/material.dart';

class FindADoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Container(
                          height: 100,
                          width: 60,
                        ),
                        title: Text('Harvey , Jasmine , MD'),
                        subtitle: Text('Radiology'),
                        trailing: InkWell(
                          onTap: () {},
                          child: Material(
                            borderRadius: BorderRadius.circular(7),
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Select'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18, right: 18, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_ios_outlined),
                      Text(
                        'Search Doctor',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 3,
                              width: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 3,
                              width: 25,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 3,
                              width: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
            left: 12,
            right: 12,
            height: MediaQuery.of(context).size.height * 0.22,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'SEARCH',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            bottom: 10, // HERE THE IMPORTANT PART
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.7),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          //  prefixIcon: Icon(Icons.search,)
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Divider(
                            height: 2,
                            thickness: 1.5,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'BRANCHES',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                        Text(
                                          'Radiology',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          width: 2,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'AVAILABILITY',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11),
                                            ),
                                            Text(
                                              '13/07/2020',
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 2,
                            thickness: 1.5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
