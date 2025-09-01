import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarus/providers/folder_provider.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;

  const FolderTile({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 130),
      child: const Stack(
        children: [
          Positioned.fill(child: Icon(Icons.folder)),
          Positioned(
            child: Align(
              child: Icon(
                size: 72,
                Icons.star_rate_rounded,
              ),
            ),
          )
        ],
      ),
    );
    //   child: (
    //     title: Text(folder.name),
    //     subtitle: Text("Created: ${folder.dateCreated}"),
    //   ),
    // );
  }
}
