import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photos/model/photo.dart';
import 'package:photos/screens/login_screen.dart';
import 'package:photos/utils/constants.dart';
import 'package:photos/utils/webservice.dart';

class PhotoListState extends State<PhotoList> {
  List<Photo> _photosArticles = List<Photo>();
  var axis = Axis.vertical;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
  }

  void _populateNewsArticles() {
    Webservice()
        .load(Photo.all)
        .then((newsArticles) => {
              setState(() => {_photosArticles = newsArticles})
            })
        .catchError((error) => print("Failed to load data: $error"));
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(2),
        width: axis == Axis.vertical
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.95,
        child: Wrap(
          children: [
            Card(
              color: Colors.white,
              child: Container(
                child: Column(
                  children: [
                    _photosArticles[index].url == null
                        ? Image.asset(NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
                        : Image.network(_photosArticles[index].url),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        _photosArticles[index].title,
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  axis =
                      axis == Axis.vertical ? Axis.horizontal : Axis.vertical;
                });
              },
              child: Icon(
                Icons.swap_horiz,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
              child: Icon(
                Icons.power_settings_new,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: _photosArticles.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                // height: axis == Axis.vertical
                //     ? MediaQuery.of(context).size.height
                //     : MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: ListView.builder(
                  scrollDirection: axis,
                  itemCount: _photosArticles.length,
                  itemBuilder: _buildItemsForListView,
                ),
              ),
            ),
    );
  }
}

class PhotoList extends StatefulWidget {
  @override
  createState() => PhotoListState();
}
