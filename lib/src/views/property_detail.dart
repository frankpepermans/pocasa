import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocasa/src/views/blocs/overview_bloc.dart';

class PropertyDetailItem extends StatelessWidget {
  final Property property;

  PropertyDetailItem({this.property});

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          property.imageUrl,
          fit: BoxFit.cover,
          height: 240,
          width: dw,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('300.000\$',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2)
                ],
              ),
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
              Text('What an awesome place to live!')
            ],
          ),
        )
      ],
    );
  }
}
