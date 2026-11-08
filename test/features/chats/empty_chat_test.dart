import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/empty_chat.dart';

void main() {
  const devices = {
    'small phone': Size(320, 568),
    'design phone': Size(402, 844),
    '11-inch tablet': Size(834, 1194),
    'large portrait tablet': Size(1024, 1366),
    'landscape tablet': Size(1366, 1024),
  };

  for (final device in devices.entries) {
    testWidgets('suggestions fit ${device.key}', (tester) async {
      await pumpEmptyChat(tester, size: device.value);

      expect(find.text('Explain'), findsOneWidget);
      expect(find.text('Write & edit'), findsOneWidget);
      expect(find.text('Translate'), findsOneWidget);
      expect(tester.takeException(), isNull);

      final tile = find.ancestor(
        of: find.text('Explain Quantum physics'),
        matching: find.byType(InkWell),
      );
      expect(tester.getSize(tile).width, lessThanOrEqualTo(544));

      await tester.ensureVisible(
        find.text('How do you say “how are you” in korean?'),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('long prompts wrap with large text and RTL', (tester) async {
    await pumpEmptyChat(
      tester,
      size: const Size(320, 568),
      textDirection: TextDirection.rtl,
      textScaler: const TextScaler.linear(2),
    );

    final lastPrompt = find.text('How do you say “how are you” in korean?');
    await tester.ensureVisible(lastPrompt);
    await tester.pumpAndSettle();

    expect(lastPrompt.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting a scrolled prompt returns its text', (tester) async {
    String? selectedPrompt;
    await pumpEmptyChat(
      tester,
      size: const Size(320, 568),
      onPromptSelected: (prompt) => selectedPrompt = prompt,
    );

    const prompt = 'How do you say “how are you” in korean?';
    await tester.ensureVisible(find.text(prompt));
    await tester.pumpAndSettle();
    await tester.tap(find.text(prompt));

    expect(selectedPrompt, prompt);
  });
}

Future<void> pumpEmptyChat(
  WidgetTester tester, {
  required Size size,
  TextDirection textDirection = TextDirection.ltr,
  TextScaler textScaler = TextScaler.noScaling,
  ValueChanged<String>? onPromptSelected,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(402, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        home: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: Directionality(
            textDirection: textDirection,
            child: Scaffold(
              body: SafeArea(
                child: EmptyChat(onPromptSelected: onPromptSelected),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
