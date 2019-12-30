import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:oauth2/oauth2.dart' as oauth;

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  int _currentPage = 1, _pageSize = 3;
  bool _hasNext = true, _hasInitialFetch = false;
  ListingSearchParameters searchParameters = const ListingSearchParameters(
      minBedrooms: 3, minBathrooms: 2, minCarspaces: 2);

  @override
  ListingsState get initialState => const ListingsIdleState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('error: $error $stacktrace');
  }

  @override
  Stream<ListingsState> mapEventToState(ListingsEvent event) async* {
    oauth.Client client;
    List<Listing> currentListings = state.listings;

    if (event is ListingsNextPageEvent) {
      if (!_hasNext) return;

      _currentPage++;

      client = event.client;
    } else if (event is ListingsFetchEvent) {
      if (_hasInitialFetch) return;

      client = event.client;
      _hasInitialFetch = true;
    } else if (event is ListingsSearchParamsEvent) {
      _currentPage = 1;
      _pageSize = 3;
      _hasNext = true;
      _hasInitialFetch = false;

      currentListings = const <Listing>[];
      client = event.client;
      searchParameters = event.params;
    }

    //yield ListingsLoadingState(params: searchParameters, listings: state.listings);

    final List list = await client
        .post('https://api.domain.com.au/v1/listings/residential/_search',
            headers: {'content-type': 'application/json'},
            body: json.encode({
              "listingType": "Sale",
              "propertyTypes": [],
              "minBedrooms": searchParameters.minBedrooms,
              "minBathrooms": searchParameters.minBathrooms,
              "minCarspaces": searchParameters.minCarspaces,
              "locations": [
                {
                  "state": "NSW",
                  "region": "",
                  "area": "",
                  "suburb": "",
                  "postCode": "2481",
                  "includeSurroundingSuburbs": false
                }
              ],
              "page": _currentPage,
              "pageSize": _pageSize
            }))
        .then((response) {
      //print('headers: "${response.request.headers}"');
      //print('raw: "${json.decode(response.body)}"');

      return json.decode(response.body);
    }, onError: (e, s) => print('listings oops! $e $s'));

    //print(json.encode(list));

    if (list == null || list.length < _pageSize) {
      _hasNext = false;
    }

    if (list != null) {
      var index = 0;

      yield ListingsPageState(params: searchParameters, listings: <Listing>[
        ...currentListings,
        ...list
            .expand((entry) => entry.containsKey('listings')
                ? entry['listings']
                : [entry['listing']])
            .map((entry) => Listing(
                id: entry['id'],
                index: state.listings.length + index++,
                images: entry['media']
                    .map((media) => media['url'])
                    .cast<String>()
                    .toList(growable: false),
                price: entry['priceDetails']['displayPrice'],
                summary: entry['headline']))
      ]);
    }
  }
}

abstract class ListingsEvent {}

class ListingsFetchEvent implements ListingsEvent {
  final oauth.Client client;

  ListingsFetchEvent(this.client);
}

class ListingsNextPageEvent implements ListingsEvent {
  final oauth.Client client;

  ListingsNextPageEvent(this.client);
}

class ListingsSearchParamsEvent implements ListingsEvent {
  final oauth.Client client;
  final ListingSearchParameters params;

  ListingsSearchParamsEvent(this.client, {this.params});
}

abstract class ListingsState {
  ListingSearchParameters get params;
  List<Listing> get listings;
}

class ListingsLoadingState implements ListingsState {
  @override
  final ListingSearchParameters params;
  @override
  final List<Listing> listings;

  ListingsLoadingState({this.params, this.listings});
}

class ListingsIdleState implements ListingsState {
  @override
  ListingSearchParameters get params => const ListingSearchParameters(
      minBedrooms: 3, minBathrooms: 2, minCarspaces: 2);
  @override
  List<Listing> get listings => const <Listing>[];

  const ListingsIdleState();
}

class ListingsPageState implements ListingsState {
  @override
  final ListingSearchParameters params;
  @override
  final List<Listing> listings;

  ListingsPageState({this.params, this.listings});
}

class Listing {
  final int id;
  final List<String> images;
  final String price, summary;
  final int index;

  const Listing(
      {@required this.index,
      @required this.id,
      @required this.images,
      @required this.price,
      @required this.summary});
}

class ListingSearchParameters {
  final int minBedrooms, minBathrooms, minCarspaces;

  const ListingSearchParameters(
      {this.minBedrooms, this.minBathrooms, this.minCarspaces});

  factory ListingSearchParameters.withMinBedrooms(
          ListingSearchParameters params, int value) =>
      ListingSearchParameters(
          minBedrooms: value,
          minBathrooms: params.minBathrooms,
          minCarspaces: params.minCarspaces);

  factory ListingSearchParameters.withMinBathrooms(
          ListingSearchParameters params, int value) =>
      ListingSearchParameters(
          minBedrooms: params.minBedrooms,
          minBathrooms: value,
          minCarspaces: params.minCarspaces);

  factory ListingSearchParameters.withMinCarSpaces(
          ListingSearchParameters params, int value) =>
      ListingSearchParameters(
          minBedrooms: params.minBedrooms,
          minBathrooms: params.minBathrooms,
          minCarspaces: value);

  List<ListingSearchParam> asList() => <ListingSearchParam>[
        if (minBedrooms > 0)
          ListingSearchParam(
              text: 'min $minBedrooms bedrooms',
              deleteHandler: (ListingSearchParameters params) =>
                  ListingSearchParameters.withMinBedrooms(params, 0)),
        if (minBathrooms > 0)
          ListingSearchParam(
              text: 'min $minBathrooms bathrooms',
              deleteHandler: (ListingSearchParameters params) =>
                  ListingSearchParameters.withMinBathrooms(params, 0)),
        if (minCarspaces > 0)
          ListingSearchParam(
              text: 'min $minCarspaces car spaces',
              deleteHandler: (ListingSearchParameters params) =>
                  ListingSearchParameters.withMinCarSpaces(params, 0))
      ];
}

class ListingSearchParam {
  final String text;
  final ListingSearchParameters Function(ListingSearchParameters params)
      deleteHandler;

  ListingSearchParam({@required this.text, @required this.deleteHandler});
}
