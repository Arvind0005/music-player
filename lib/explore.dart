import 'package:flutter/material.dart';
import 'package:musicapp002/pagestyling.dart';

////implementation 'com.google.firebase:firebase-core:17.5.0'
class Explore extends StatelessWidget {
  final String username;
  Explore({Key key,this.username}): super(key: key);
  @override
  Widget build(BuildContext context) {
    print("jhcbdvycvsgd");
    return Container(
      child: ListView(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(45.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Popular Songs",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[400].withOpacity(1.0),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  height: 250,
                )
              ],
            ),
          )
        ],
      ),
      decoration: pagestyling,
    );
  }
}
