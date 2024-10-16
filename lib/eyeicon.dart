import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'editable.dart';

class EyeIcon extends ConsumerWidget {
  const EyeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(ref.watch(editableProvider) ? Icons.visibility : Icons.edit),
      onPressed: () => ref.read(editableProvider.notifier).change(),
    );
  }
}
