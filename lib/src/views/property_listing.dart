import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pocasa/src/views/blocs/overview_bloc.dart';
import 'package:pocasa/src/views/property_detail.dart';

class PropertyListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<OverviewBloc>(context);

    return BlocBuilder(
        key: Key('overview'),
        bloc: bloc,
        builder: (context, OverviewState snapshot) {
          return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              scrollDirection: Axis.vertical,
              child: Column(
                children: snapshot.images
                    .map((property) => PropertyListItem(property: property))
                    .toList(growable: false),
              ));
        });
  }
}

class PropertyListItem extends StatelessWidget {
  final Property property;

  PropertyListItem({this.property});

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width - 40;
    const iconData = IconData(0xe800, fontFamily: 'MyFlutterApp');

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
                child: Image.asset(
                  property.imageUrl,
                  fit: BoxFit.cover,
                  height: 220,
                  width: dw,
                ),
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  final pos = box.localToGlobal(Offset.zero);

                  Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Scaffold(
                      body: PropertyDetailItem(
                        property: property,
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final tween = Tween(
                              begin: Offset(0.0,
                                  pos.dy / MediaQuery.of(context).size.height),
                              end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeOut));
                      final sizeTween = Tween(
                              begin: (MediaQuery.of(context).size.width - 40) /
                                  MediaQuery.of(context).size.width,
                              end: 1.0)
                          .chain(CurveTween(curve: Curves.easeIn));

                      return ScaleTransition(
                        scale: animation.drive(sizeTween),
                        child: SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        ),
                      );
                    },
                  ));
                }),
            Container(
              child: Text('300.000\$',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              alignment: Alignment.topRight,
              width: dw,
              color: Colors.grey[200],
            ),
            Container(
              child: Text(
                  'Very nice house with a proper garden where your pets can play all day long',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              width: dw,
              color: Colors.grey[200],
            ),
          ],
        ),
        Positioned(
          child: Container(
            width: 32,
            height: 32,
            decoration: const ShapeDecoration(
                color: Colors.white, shape: CircleBorder()),
            child: IconButton(
              icon: Icon(
                iconData,
                size: 16,
              ),
              onPressed: () => print('like!'),
              color: Colors.pinkAccent,
            ),
          ),
          right: 6,
          top: 6,
        ),
      ],
    );
  }
}
