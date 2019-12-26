import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pocasa/src/views/blocs/carousel_bloc.dart';
import 'package:pocasa/src/views/blocs/listings_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PropertyCarousel extends StatelessWidget {
  final Listing listing;
  final Key key;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  PropertyCarousel(this.listing, {this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CarouselBloc>(context);
    final dw = MediaQuery.of(context).size.width - 40;
    final BehaviorSubject<int> pageController = BehaviorSubject<int>.seeded(0);

    return BlocBuilder(
        bloc: bloc,
        builder: (context, CarouselState snapshot) {
          final page = snapshot.indices[listing] ?? 0;

          final child = Stack(
            children: [
              SizedBox(
                height: 220,
                child: Swiper(
                  key: UniqueKey(),
                  itemCount: listing.images.length,
                  onIndexChanged: (page) {
                    bloc.add(CarouselUpdateEvent(listing, page));
                    pageController.add(page);
                  },
                  viewportFraction: 1.0,
                  index: page,
                  itemBuilder: (BuildContext context, int index) =>
                      CachedNetworkImage(
                    imageUrl: listing.images[index],
                    placeholder: (context, url) => Container(
                      child: Column(
                        children: <Widget>[CircularProgressIndicator()],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      width: dw,
                      height: 220,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: StreamBuilder(
                  stream: pageController,
                  builder: (context, AsyncSnapshot<int> snapshot) =>
                      _ImageIndexIndicatorWidget(listing, snapshot.data ?? 1),
                ),
              )
            ],
          );

          return child;
        });
  }
}

class _ImageIndexIndicatorWidget extends StatelessWidget {
  final Listing listing;
  final int page;

  _ImageIndexIndicatorWidget(this.listing, this.page) {
    assert(listing != null);
    assert(page != null);
  }

  @override
  Widget build(BuildContext context) {
    print(page);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          listing.images.length,
          (index) => Container(
                child: Icon(
                  (index == page) ? Icons.trip_origin : Icons.brightness_1,
                  color: Colors.white,
                  size: 12,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4),
              )).toList(growable: false),
    );
  }
}
