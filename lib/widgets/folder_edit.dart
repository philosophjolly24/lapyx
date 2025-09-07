import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/folder_provider.dart';
import 'package:icarus/widgets/custom_button.dart';
import 'package:icarus/widgets/custom_text_field.dart';
import 'package:icarus/widgets/dot_painter.dart';
import 'package:icarus/widgets/folder_tile.dart';

class FolderEditDialog extends ConsumerStatefulWidget {
  const FolderEditDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FolderEditDialogState();
}

class _FolderEditDialogState extends ConsumerState<FolderEditDialog> {
  final TextEditingController _folderNameController = TextEditingController();
  final IconData _selectedIcon = Folder.folderIcons[0];
  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Listen to text changes and rebuild
    _folderNameController.addListener(() {
      setState(() {
        // This will trigger a rebuild when text changes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Settings.highlightColor, width: 2),
        ),
        backgroundColor: Settings.sideBarColor,
        title: const Text("Add Folder"),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 300,
              width: 358,
              decoration: BoxDecoration(
                color: Settings.abilityBGColor,
                border: Border.all(
                  color: Settings.highlightColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                      child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: DotGrid(),
                    ),
                  )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: FolderTile(
                          folder: Folder(
                            name: _folderNameController.text,
                            id: "null",
                            dateCreated: DateTime.now(),
                          ),
                          isDemo: true,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: 358,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Settings.highlightColor,
                  width: 1,
                ),
                color: Settings.abilityBGColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // Number of icons per row
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: Folder.folderIcons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle icon selection
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Center(
                        child: Icon(
                          Folder.folderIcons[index],
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 358,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                      height: 40,
                      child: CustomTextField(
                        hintText: "Folder Name",
                        textAlign: TextAlign.center,
                        controller: _folderNameController,
                      )),
                ),
                const SizedBox(width: 30),
                CustomButton(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  ),
                  onPressed: () {
                    // Show create strategy dialog
                  },
                  height: 40,
                  width: 80,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: "Done",
                  fontWeight: FontWeight.normal,
                  labelColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),

                // TextButton.icon(
                //   icon: const Icon(Icons.check, color: Colors.white),
                //   onPressed: () {
                //     // Save changes
                //   },
                //   label: const Text("Save"),
                // ),
              ],
            ),
          )
        ]);
  }
}
