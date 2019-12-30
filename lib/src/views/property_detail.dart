import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocasa/src/views/blocs/listings_bloc.dart';
import 'package:pocasa/src/views/property_carousel.dart';

class PropertyDetailItem extends StatelessWidget {
  final Listing listing;

  PropertyDetailItem({this.listing});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PropertyCarousel(
            listing,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(listing.price,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.hotel,
                      ),
                      onPressed: () => print('like!'),
                      color: Colors.black,
                    ),
                    Text('3'),
                    IconButton(
                      icon: Icon(
                        Icons.restaurant,
                      ),
                      onPressed: () => print('like!'),
                      color: Colors.black,
                    ),
                    Text('1')
                  ],
                ),
                Text(listing.summary,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2)
              ],
            ),
          )
        ],
      );
}
