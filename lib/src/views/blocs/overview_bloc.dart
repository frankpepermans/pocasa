import 'package:bloc/bloc.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  @override
  OverviewState get initialState => const OverviewIdleState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('error: $error');
  }

  @override
  Stream<OverviewState> mapEventToState(OverviewEvent event) async* {
    if (event is OverviewResetEvent) {
      yield const OverviewIdleState();
    } else if (event is OverviewSelectEvent) {
      final selectedProperty = state.images[event.selectedIndex];

      yield OverviewSelectedState(
          selectedProperty, state.images.toList(growable: false), 0);
    }
  }
}

abstract class OverviewEvent {}

class OverviewResetEvent implements OverviewEvent {
  const OverviewResetEvent();
}

class OverviewSelectEvent implements OverviewEvent {
  final int selectedIndex;

  const OverviewSelectEvent(this.selectedIndex);
}

class OverviewNextCardIndexEvent implements OverviewEvent {
  const OverviewNextCardIndexEvent();
}

abstract class OverviewState {
  bool get hasSelection;
  List<Property> get images;
  Property get selectedImage;
  int get cardIndex;
}

class OverviewIdleState implements OverviewState {
  @override
  bool get hasSelection => false;

  @override
  Property get selectedImage => null;

  @override
  int get cardIndex => 0;

  @override
  List<Property> get images => const <Property>[
        Property(0, 'assets/frontyard (14).jpeg'),
        Property(1, 'assets/frontyard (2).jpeg'),
        Property(2, 'assets/frontyard (3).jpeg'),
        Property(3, 'assets/frontyard (4).jpeg'),
        Property(4, 'assets/frontyard (5).jpeg'),
        Property(5, 'assets/frontyard (6).jpeg'),
        Property(6, 'assets/frontyard (7).jpeg'),
        Property(7, 'assets/frontyard (8).jpeg'),
        Property(8, 'assets/frontyard (9).jpeg'),
        Property(9, 'assets/frontyard (10).jpeg'),
        Property(10, 'assets/frontyard (11).jpeg'),
        Property(11, 'assets/frontyard (12).jpeg'),
        Property(12, 'assets/frontyard (13).jpeg'),
        Property(13, 'assets/frontyard (1).jpeg'),
        Property(14, 'assets/frontyard (2).jpeg'),
        Property(15, 'assets/frontyard (3).jpeg'),
        Property(16, 'assets/frontyard (4).jpeg'),
        Property(17, 'assets/frontyard (5).jpeg'),
        Property(18, 'assets/frontyard (6).jpeg'),
        Property(19, 'assets/frontyard (7).jpeg'),
        Property(20, 'assets/frontyard (8).jpeg'),
        Property(21, 'assets/frontyard (9).jpeg'),
        Property(22, 'assets/frontyard (10).jpeg'),
        Property(23, 'assets/frontyard (11).jpeg'),
        Property(24, 'assets/frontyard (12).jpeg'),
        Property(25, 'assets/frontyard (13).jpeg'),
      ];

  const OverviewIdleState();
}

class OverviewSelectedState implements OverviewState {
  @override
  bool get hasSelection => true;

  @override
  final Property selectedImage;

  @override
  final List<Property> images;

  @override
  final int cardIndex;

  OverviewSelectedState(this.selectedImage, this.images, this.cardIndex);
}

class Property {
  final String imageUrl;
  final int index;

  const Property(this.index, this.imageUrl);
}
