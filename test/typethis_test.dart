import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typethis/typethis.dart';

import 'helpers/helpers.dart';

void main() {
  group('TypeThis', () {
    const testString = 'This is a test string';
    const testSpeed = 50;

    Widget buildSubject({
      String string = testString,
      int speed = testSpeed,
      TextAlign textAlign = TextAlign.center,
      TextStyle style = const TextStyle(),
    }) {
      return TypeThis(
        string: string,
        speed: speed,
        textAlign: textAlign,
        style: style,
      );
    }

    group(': constructor', () {
      test('works perfectly', () {
        expect(
          () => const TypeThis(string: testString),
          returnsNormally,
        );
      });
    });

    group(': text widget', () {
      group('animation', () {
        testWidgets(
          'has started rendering and string is empty',
          (widgetTester) async {
            await widgetTester.pumpApp(buildSubject());
            await widgetTester.pump();

            final finder = find.byType(Text);
            expect(finder, findsOneWidget);

            final textWidget = widgetTester.firstWidget<Text>(finder);
            expect(textWidget.data, equals(''));
          },
        );

        testWidgets(
          'renders first 3 characters after (3 * testSpeed)ms duration',
          (widgetTester) async {
            await widgetTester.pumpApp(buildSubject());
            await widgetTester
                .pump(const Duration(milliseconds: testSpeed * 3));

            final finder = find.byType(Text);
            expect(finder, findsOneWidget);

            final textWidget = widgetTester.firstWidget<Text>(finder);
            expect(textWidget.data, equals(testString.substring(0, 3)));
          },
        );

        testWidgets(
          'has finished rendereing and whole string is present',
          (widgetTester) async {
            await widgetTester.pumpApp(buildSubject());
            await widgetTester.pumpAndSettle();

            final finder = find.byType(Text);
            expect(finder, findsOneWidget);

            final textWidget = widgetTester.firstWidget<Text>(finder);
            expect(textWidget.data, equals(testString));
          },
        );
      });

      testWidgets(
        'textAlign property is same as provided',
        (widgetTester) async {
          const testTextAlign = TextAlign.start;

          await widgetTester.pumpApp(
            buildSubject(textAlign: testTextAlign),
          );
          await widgetTester.pumpAndSettle();

          final finder = find.byType(Text);
          expect(finder, findsOneWidget);

          final textWidget = widgetTester.firstWidget<Text>(finder);
          expect(textWidget.textAlign, equals(testTextAlign));
        },
      );

      testWidgets(
        'style property is same as provided',
        (widgetTester) async {
          const testStyle = TextStyle(fontSize: 28, color: Colors.black87);

          await widgetTester.pumpApp(
            buildSubject(style: testStyle),
          );
          await widgetTester.pumpAndSettle();

          final finder = find.byType(Text);
          expect(finder, findsOneWidget);

          final textWidget = widgetTester.firstWidget<Text>(finder);
          expect(textWidget.style?.fontSize, equals(testStyle.fontSize));
          expect(textWidget.style?.color, equals(testStyle.color));
        },
      );
    });
  });
}
