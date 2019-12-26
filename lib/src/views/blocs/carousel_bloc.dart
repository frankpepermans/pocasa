import 'package:bloc/bloc.dart';
import 'package:pocasa/src/views/blocs/listings_bloc.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  Map<Listing, int> _next = const <Listing, int>{};

  @override
  CarouselState get initialState => const CarouselIdleState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('error: $error $stacktrace');
  }

  @override
  Stream<CarouselState> mapEventToState(CarouselEvent event) async* {
    if (event is CarouselUpdateEvent) {
      _next = Map<Listing, int>.from(_next);

      _next[event.listing] = event.page;
    } else if (event is CarouselPushEvent) {
      yield CarouselUpdatedState(Map<Listing, int>.unmodifiable(_next));
    }
  }
}

abstract class CarouselEvent {}

class CarouselUpdateEvent implements CarouselEvent {
  final Listing listing;
  final int page;

  CarouselUpdateEvent(this.listing, this.page);
}

class CarouselPushEvent implements CarouselEvent {
  const CarouselPushEvent();
}

abstract class CarouselState {
  Map<Listing, int> get indices;
}

class CarouselIdleState implements CarouselState {
  @override
  Map<Listing, int> get indices => const <Listing, int>{};

  const CarouselIdleState();
}

class CarouselUpdatedState implements CarouselState {
  @override
  final Map<Listing, int> indices;

  CarouselUpdatedState(this.indices);
}
