import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onExit;

  const AppHeader({super.key, required this.title, this.onBack, this.onExit});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack ?? () => Navigator.maybePop(context),
      ),
      actions: [IconButton(icon: const Icon(Icons.close), onPressed: onExit)],
    );
  }
}
