import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:besties_notes/common/app_colors.dart';

class AvatarPickerField extends StatelessWidget {
  final String? avatarPath;
  final IconData defaultIcon;
  final ValueChanged<String?> onChanged;

  const AvatarPickerField({
    super.key,
    required this.avatarPath,
    required this.onChanged,
    this.defaultIcon = Icons.person,
  });

  Future<void> _pickAvatar(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => _imageSourceModal(ctx),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(picked.path);
    final savedPath = p.join(
      appDir.path,
      'avatars',
      '${DateTime.now().millisecondsSinceEpoch}$ext',
    );
    await Directory(p.dirname(savedPath)).create(recursive: true);
    await File(picked.path).copy(savedPath);

    onChanged(savedPath);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _pickAvatar(context),
        child: Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentPink, width: 2),
                color: AppColors.softWarmPink,
              ),
              child: avatarPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(avatarPath!),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(defaultIcon, size: 40, color: AppColors.accentPink),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.accentPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSourceModal(BuildContext ctx) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          if (avatarPath != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                onChanged(null);
                Navigator.pop(ctx);
              },
            ),
        ],
      ),
    );
  }
}
