import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocasa/src/views/blocs/listings_bloc.dart';
import 'package:rxdart/rxdart.dart';

/*class Overview extends StatelessWidget {
  final BoxConstraints constraints;

  Overview({this.constraints});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ListingsBloc>(context);
    var lastOffset = .0;

    imageCache.clear();

    return BlocBuilder(
        key: Key('overview'),
        bloc: bloc,
        builder: (context, ListingsState snapshot) {
          final screenResolver = () {
            final controller = ScrollController();

            controller.addListener(() => lastOffset = controller.offset);

            return SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.vertical,
              physics: snapshot.hasSelection
                  ? const NeverScrollableScrollPhysics()
                  : const ScrollPhysics(),
              child: Container(
                height: constraints.maxHeight /
                    2 *
                    (snapshot.images.length / 3).ceil(),
                child: Stack(
                    children: snapshot.images.map((property) {
                  final isSelected = snapshot.selectedImage == property;
                  final isVisible =
                      snapshot.selectedImage == null || isSelected;
                  final dw = constraints.maxWidth, dh = constraints.maxHeight;
                  final index = property.index;
                  final group = index ~/ 3;
                  final groupIndex = index % 3;
                  final isBig = group.isEven && groupIndex == 0 ||
                      !group.isEven && groupIndex == 2;
                  final width = isBig ? 2 * dw / 3 : dw / 3,
                      height = isBig ? dh / 2 : dh / 4;
                  var y = group * dh / 2;
                  double x;

                  if (group.isEven) {
                    x = isBig ? 0 : 2 * dw / 3;

                    if (!isBig && groupIndex == 2) {
                      y += dh / 4;
                    }
                  } else {
                    x = isBig ? dw / 3 : 0;

                    if (!isBig && groupIndex == 1) {
                      y += dh / 4;
                    }
                  }

                  /*if (snapshot.selectedImage != null) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => controller.jumpTo(0));
                    }*/

                  return Visibility(
                    child: AnimatedPositioned(
                        left: isSelected ? 0 : x,
                        top: isSelected ? lastOffset : y,
                        duration: const Duration(milliseconds: 240),
                        child: GestureDetector(
                          child: AnimatedContainer(
                              child: IndexedStack(
                                index: snapshot.cardIndex,
                                sizing: StackFit.expand,
                                children: [
                                  GestureDetector(
                                    child: Image.asset(
                                      property.imageUrl,
                                      width: isSelected
                                          ? constraints.maxWidth
                                          : width,
                                      height: isSelected
                                          ? constraints.maxHeight / 2
                                          : height,
                                      fit: BoxFit.cover,
                                    ),
                                    onHorizontalDragEnd: (_) => bloc.add(
                                        const OverviewNextCardIndexEvent()),
                                  )
                                ],
                              ),
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.fastOutSlowIn,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              padding: isSelected
                                  ? const EdgeInsets.all(.0)
                                  : const EdgeInsets.all(4.0)),
                          onTap: () =>
                              bloc.add(OverviewSelectEvent(property.index)),
                        )),
                    visible: isVisible,
                  );
                }).toList(growable: false)),
              ),
            );
          };

          return WillPopScope(
            onWillPop: () async {
              if (snapshot is OverviewSelectedState) {
                bloc.add(const OverviewResetEvent());

                return false;
              }

              bloc.close();

              return true;
            },
            child: screenResolver(),
          );
        });
  }
}*/
