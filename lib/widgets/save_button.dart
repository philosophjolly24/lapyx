import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/agent_provider.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          ref.read(agentProvider.notifier).fromJson(
              '[{"position":{"dx":782.4151234567901,"dy":507.8462577160494},"type":"clove"},{"position":{"dx":729.5873521090534,"dy":465.34529320987656},"type":"breach"},{"position":{"dx":721.0360403806585,"dy":328.2696759259259},"type":"jett"},{"position":{"dx":823.7614133230452,"dy":304.84664351851853},"type":"raze"}]');
        },
        icon: const Icon(Icons.save),
      ),
    );
  }
}
