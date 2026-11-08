import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/message_bubble.dart';

void main() {
  const sizes = [
    Size(320, 568),
    Size(402, 844),
    Size(834, 1194),
    Size(1024, 1366),
    Size(1366, 1024),
  ];

  for (final size in sizes) {
    testWidgets('long messages wrap within ${size.width} x ${size.height}', (
      tester,
    ) async {
      await pumpBubbles(
        tester,
        size: size,
        message: List.filled(20, 'A long chat message that needs to wrap.')
            .join(' '),
      );

      expect(tester.takeException(), isNull);
      for (var index = 0; index < 2; index++) {
        final rect = tester.getRect(bubbleSurface(index));
        expect(rect.left, greaterThanOrEqualTo(16));
        expect(rect.right, lessThanOrEqualTo(size.width - 16));
        expect(rect.width, lessThanOrEqualTo(640));
      }
    });
  }

  for (final direction in TextDirection.values) {
    testWidgets('sender alignment follows $direction with large text', (
      tester,
    ) async {
      await pumpBubbles(
        tester,
        size: const Size(320, 568),
        direction: direction,
        textScaler: const TextScaler.linear(2),
      );

      final user = tester.getRect(bubbleSurface(0));
      final model = tester.getRect(bubbleSurface(1));
      if (direction == TextDirection.ltr) {
        expect(user.right, closeTo(304, 0.1));
        expect(model.left, closeTo(16, 0.1));
      } else {
        expect(user.left, closeTo(16, 0.1));
        expect(model.right, closeTo(304, 0.1));
      }
      expect(tester.takeException(), isNull);
    });
  }
}

Finder bubbleSurface(int index) => find.descendant(
      of: find.byType(MessageBubble).at(index),
      matching: find.byType(DecoratedBox),
    );

Future<void> pumpBubbles(
  WidgetTester tester, {
  required Size size,
  String message = 'Hello there',
  TextDirection direction = TextDirection.ltr,
  TextScaler textScaler = TextScaler.noScaling,
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
            textDirection: direction,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    MessageBubble(message: message, type: MessageType.user),
                    MessageBubble(message: message, type: MessageType.model),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
