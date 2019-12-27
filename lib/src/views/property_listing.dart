import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocasa/src/views/blocs/carousel_bloc.dart';

import 'package:pocasa/src/views/blocs/listings_bloc.dart';
import 'package:pocasa/src/views/blocs/login_bloc.dart';
import 'package:pocasa/src/views/property_carousel.dart';
import 'package:pocasa/src/views/property_detail.dart';

class PropertyListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final bloc = BlocProvider.of<ListingsBloc>(context);
    final controller = ScrollController();

    return BlocBuilder(
        bloc: loginBloc,
        builder: (context, LoginState snapshot) {
          if (snapshot is LoginSuccessState) {
            bloc.add(ListingsFetchEvent(snapshot.client));

            controller.addListener(() {
              if (controller.position.atEdge &&
                  controller.offset == controller.position.maxScrollExtent) {
                bloc.add(ListingsNextPageEvent(snapshot.client));
              }
            });

            return BlocBuilder(
                bloc: bloc,
                builder: (context, ListingsState snapshot) => ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          PropertyListItem(listing: snapshot.listings[index]),
                      itemCount: snapshot.listings.length,
                      controller: controller,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      scrollDirection: Axis.vertical,
                    ));
          }

          return Text('loading...');
        });
  }
}

class PropertyListItem extends StatelessWidget {
  final Listing listing;

  PropertyListItem({this.listing});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CarouselBloc>(context);
    final dw = MediaQuery.of(context).size.width - 40;
    const iconData = IconData(0xe800, fontFamily: 'MyFlutterApp');

    bloc.add(const CarouselPushEvent());

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
                child: PropertyCarousel(
                  listing,
                ),
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  final pos = box.localToGlobal(Offset.zero);

                  bloc.add(const CarouselPushEvent());

                  Navigator.of(context).push(DetailPage(
                    property: listing,
                    pos: pos,
                  ));
                }),
            Container(
              child: Text(listing.price,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              alignment: Alignment.topRight,
              width: dw,
              color: Colors.grey[200],
            ),
            Container(
              child: Text(listing.summary,
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

class DetailPage extends PageRouteBuilder {
  final Listing property;
  final Offset pos;

  DetailPage({this.property, this.pos})
      : super(
            opaque: true,
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) =>
                build(property),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    buildTransition(
                        context, animation, secondaryAnimation, child, pos));

  static Widget build(Listing property) => Scaffold(
        body: PropertyDetailItem(
          listing: property,
        ),
      );

  static AnimatedWidget buildTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      Offset pos) {
    final tween = Tween(
            begin: Offset(0.0, pos.dy / MediaQuery.of(context).size.height),
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
  }
}
