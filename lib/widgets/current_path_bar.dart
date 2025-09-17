import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/folder_provider.dart';

class CurrentPathBar extends ConsumerWidget {
  const CurrentPathBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFolderId = ref.watch(folderProvider);
    final currentFolder = currentFolderId != null
        ? ref.read(folderProvider.notifier).findFolderByID(currentFolderId)
        : null;

    final pathIds =
        ref.read(folderProvider.notifier).getFullPathIDs(currentFolder);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Root folder button
          FolderTab(
            folder: null, // Represents root
            isActive: currentFolderId == null,
          ),
          // Path folders
          for (int i = 0; i < pathIds.length; i++) ...[
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            FolderTab(
              folder:
                  ref.read(folderProvider.notifier).findFolderByID(pathIds[i]),
              isActive: i == pathIds.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class FolderTab extends ConsumerWidget {
  const FolderTab({
    super.key,
    required this.folder,
    this.isActive = false,
  });

  final Folder? folder; // null for root
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = folder?.name ?? "Strategies";

    return InkWell(
      onTap: isActive
          ? null
          : () {
              // Navigate to this folder
              ref.read(folderProvider.notifier).updateID(folder?.id);
            },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive && folder != null
              ? Colors.deepPurpleAccent.withOpacity(0.2)
              : null,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          displayName,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
