import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:oauth2/oauth2.dart' as oauth;

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  int _currentPage = 1, _pageSize = 3;
  bool _hasNext = true, _hasInitialFetch = false;

  @override
  ListingsState get initialState => const ListingsIdleState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('error: $error $stacktrace');
  }

  @override
  Stream<ListingsState> mapEventToState(ListingsEvent event) async* {
    oauth.Client client;

    if (event is ListingsNextPageEvent) {
      if (!_hasNext) return;
      print('NEXT PAGE');
      _currentPage++;

      client = event.client;
    } else if (event is ListingsFetchEvent) {
      if (_hasInitialFetch) return;

      client = event.client;
      _hasInitialFetch = true;
    }
    print('Page: $_currentPage');
    final List list = await client
        .post('https://api.domain.com.au/v1/listings/residential/_search',
            headers: {'content-type': 'application/json'},
            body: json.encode({
              "listingType": "Sale",
              "propertyTypes": [],
              "minBedrooms": 0,
              "minBathrooms": 0,
              "minCarspaces": 0,
              "locations": [
                {
                  "state": "SA",
                  "region": "",
                  "area": "",
                  "suburb": "",
                  "postCode": "",
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

    if (list == null || list.length < _pageSize) {
      _hasNext = false;
    }

    if (list != null) {
      var index = 0;

      yield ListingsPageState(listings: <Listing>[
        ...state.listings,
        ...list
            .expand((entry) => entry.containsKey('listings')
                ? entry['listings']
                : [entry['listing']])
            .map((entry) => Listing(
                index: state.listings.length + index++,
                imageUrl: entry['media'].first['url'],
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

abstract class ListingsState {
  List<Listing> get listings;
}

class ListingsIdleState implements ListingsState {
  @override
  List<Listing> get listings => const <Listing>[];

  const ListingsIdleState();
}

class ListingsPageState implements ListingsState {
  @override
  final List<Listing> listings;

  ListingsPageState({this.listings});
}

class Listing {
  final String imageUrl, price, summary;
  final int index;

  const Listing({this.index, this.imageUrl, this.price, this.summary});
}
