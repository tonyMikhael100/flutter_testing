import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/core/themes/app_theme.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/send_message_footer.dart';

void main() {
  const sizes = [
    Size(320, 568),
    Size(402, 844),
    Size(834, 1194),
    Size(1024, 1366),
    Size(1366, 1024),
  ];

  for (final size in sizes) {
    testWidgets('composer fits ${size.width} x ${size.height}', (tester) async {
      await pumpFooter(tester, size: size);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byTooltip('Voice input').hitTestable(), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.send_rounded).hitTestable(),
          findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TextField)).width, greaterThan(100));
    });
  }

  testWidgets('sends trimmed text, clears draft, and ignores blank messages', (
    tester,
  ) async {
    final messages = <String>[];
    await pumpFooter(tester, onSend: messages.add);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.widgetWithIcon(IconButton, Icons.send_rounded));
    expect(messages, isEmpty);

    await tester.enterText(find.byType(TextField), '  Hello chatGPT  ');
    await tester.pump();
    await tester.tap(find.widgetWithIcon(IconButton, Icons.send_rounded));
    await tester.pump();

    expect(messages, ['Hello chatGPT']);
    expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text, '');

    await tester.enterText(find.byType(TextField), 'Keyboard message');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    expect(messages, ['Hello chatGPT', 'Keyboard message']);
  });

  testWidgets('microphone invokes the supplied voice callback', (tester) async {
    var voiceRequests = 0;
    await pumpFooter(tester, onMicrophonePressed: () => voiceRequests++);

    await tester.tap(find.byTooltip('Voice input'));

    expect(voiceRequests, 1);
  });

  testWidgets('large RTL drafts stay above the keyboard on a small phone', (
    tester,
  ) async {
    await pumpFooter(
      tester,
      size: const Size(320, 568),
      keyboardInset: 240,
      textDirection: TextDirection.rtl,
      textScaler: const TextScaler.linear(2),
    );
    await tester.enterText(
      find.byType(TextField),
      'رسالة طويلة عشان نجرب الكتابة على أكتر من سطر من غير مشاكل في المساحة',
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester
          .getBottomRight(find.widgetWithIcon(IconButton, Icons.send_rounded))
          .dy,
      lessThanOrEqualTo(568 - 240),
    );
  });
}

Future<void> pumpFooter(
  WidgetTester tester, {
  Size size = const Size(402, 844),
  double keyboardInset = 0,
  TextDirection textDirection = TextDirection.ltr,
  TextScaler textScaler = TextScaler.noScaling,
  ValueChanged<String>? onSend,
  VoidCallback? onMicrophonePressed,
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
        theme: AppTheme.lightTheme,
        home: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            viewInsets: EdgeInsets.only(bottom: keyboardInset),
            textScaler: textScaler,
          ),
          child: Directionality(
            textDirection: textDirection,
            child: Scaffold(
              body: const SizedBox.expand(),
              bottomNavigationBar: SendMessageFooter(
                onSend: onSend,
                onMicrophonePressed: onMicrophonePressed,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
