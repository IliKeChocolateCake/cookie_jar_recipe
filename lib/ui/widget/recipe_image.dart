import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeImage extends StatelessWidget {
  final String? path;
  const RecipeImage({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    final p = path;
    if (p == null || p.isEmpty) return const _Placeholder();

    if (p.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: p,
        fit: BoxFit.cover,
        placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, _, _) => const _Placeholder(),
      );
    }

    if (p.startsWith('assets/') || p.startsWith('asset/')) {
      return Image.asset(
        p,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _Placeholder(),
      );
    }

    if (kIsWeb) return const _Placeholder(); // local files can't load on web

    return Image.file(
      File(p),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.cookie,
          size: 40,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}