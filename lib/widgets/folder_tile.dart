import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/folder_provider.dart';
import 'package:icarus/widgets/custom_folder_painter.dart';
import 'package:icarus/widgets/folder_view.dart';

class FolderTile extends ConsumerStatefulWidget {
  const FolderTile({
    super.key,
    required this.folder,
  });
  final Folder folder;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FolderTileState();
}

class _FolderTileState extends ConsumerState<FolderTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xffD2D6DB).withAlpha((255.0 * 0.102).round()),
      end: Colors.deepPurpleAccent,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 558 / 445,
      child: GestureDetector(
        onTap: () {
          ref.read(folderProvider.notifier).updateID(widget.folder.id);
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => FolderView(folder: widget.folder),
            ),
          );
        },
        child: MouseRegion(
          onEnter: (_) {
            _animationController.forward();
          },
          onExit: (_) {
            _animationController.reverse();
          },
          cursor: SystemMouseCursors.click,
          child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CustomFolderPainter(
                        strokeColor:
                            _colorAnimation.value ?? const Color(0xFF272528),
                      ),
                    ),
                  ),
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        size: 92,
                        Icons.star_rate_rounded,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
