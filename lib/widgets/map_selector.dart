import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/widgets/map_tile.dart';

class MapSelector extends ConsumerStatefulWidget {
  const MapSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapSelectorState();
}

class _MapSelectorState extends ConsumerState<MapSelector> {
  final OverlayPortalController _controller = OverlayPortalController();
  final _link = LayerLink();
  double _containerHeight = 0;
  bool _isOpen = false;

  void _closePortal() {
    // For closing, animate to zero first
    setState(() {
      _containerHeight = 0;
      _isOpen = false;
    });

    // Then hide the overlay after animation completes
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.hide();
    });
  }

  void _openPortal() {
    // First show the overlay with zero size
    _controller.show();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _containerHeight = 500;
        _isOpen = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMap = ref.watch(mapProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: CompositedTransformTarget(
        link: _link,
        child: Container(
          decoration: BoxDecoration(
            color: Settings.sideBarColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Settings.highlightColor,
              width: 2,
            ),
          ),
          width: 262,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                OverlayPortal(
                  controller: _controller,
                  overlayChildBuilder: (context) {
                    return CompositedTransformFollower(
                      link: _link,
                      targetAnchor: Alignment.bottomLeft,
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: _containerHeight,
                            width: 260,
                            decoration: BoxDecoration(
                              color: Settings.sideBarColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Settings.highlightColor,
                                width: 2,
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: Maps.maps.length,
                              itemBuilder: (context, index) {
                                MapValue mapValue =
                                    Maps.maps.keys.elementAt(index);
                                String mapName = Maps.maps[mapValue]!;

                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: MapTile(
                                    name: mapName,
                                    onTap: () {
                                      ref
                                          .read(mapProvider.notifier)
                                          .updateMap(mapValue);

                                      _closePortal();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: MapTile(
                      name: Maps.maps[currentMap]!,
                      onTap: () {
                        if (!_isOpen) {
                          _openPortal();
                        } else {
                          _closePortal();
                        }
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Column(
                      children: [
                        Icon(
                          Icons.upcoming,
                          size: 17,
                        ),
                        Text("Attack")
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
