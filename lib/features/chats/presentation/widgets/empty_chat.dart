import 'package:flutter/material.dart';

import 'chat_suggestion_section.dart';

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key, this.onPromptSelected});

  final ValueChanged<String>? onPromptSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 28),
            child: Column(
              children: [
                ChatSuggestionSection(
                  icon: Icons.subject_outlined,
                  title: 'Explain',
                  prompts: const [
                    'Explain Quantum physics',
                    'What are wormholes explain like i am 5',
                  ],
                  onPromptSelected: onPromptSelected,
                ),
                const SizedBox(height: 44),
                ChatSuggestionSection(
                  icon: Icons.edit_note_outlined,
                  title: 'Write & edit',
                  prompts: const [
                    'Write a tweet about global warming',
                    'Write a poem about flower and love',
                    'Write a rap song lyrics about',
                  ],
                  onPromptSelected: onPromptSelected,
                ),
                const SizedBox(height: 44),
                ChatSuggestionSection(
                  icon: Icons.translate_rounded,
                  title: 'Translate',
                  prompts: const [
                    'How do you say “how are you” in korean?',
                    'Write a poem about flower and love',
                  ],
                  onPromptSelected: onPromptSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
