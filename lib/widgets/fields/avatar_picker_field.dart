import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';

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
    final tokens = context.tokens;
    const size = 88.0;

    return Center(
      child: Semantics(
        button: true,
        label: avatarPath != null
            ? context.l10n.photoChange
            : context.l10n.photoAdd,
        child: GestureDetector(
          onTap: () => _pickAvatar(context),
          child: Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tokens.accentSoft,
                ),
                child: avatarPath != null
                    ? ClipOval(
                        child: Image.file(
                          File(avatarPath!),
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(defaultIcon, size: 40, color: tokens.accent),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: tokens.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: tokens.bg, width: 2),
                  ),
                  child: Icon(
                    Icons.photo_camera_rounded,
                    size: 16,
                    color: tokens.onAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSourceModal(BuildContext ctx) {
    final danger = ctx.tokens.danger;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(ctx.l10n.photoFromGallery),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(ctx.l10n.photoTake),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          if (avatarPath != null)
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: danger),
              title: Text(
                ctx.l10n.photoRemove,
                style: TextStyle(color: danger),
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
