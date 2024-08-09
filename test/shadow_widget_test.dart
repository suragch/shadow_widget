import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_widget/shadow_widget.dart';

void main() {
  testWidgets('Shadow widget applies correct parameters', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShadowWidget(
            color: Colors.black,
            offset: const Offset(2, 2),
            blurRadius: 5,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    final shadowWidget = tester.widget<ShadowWidget>(find.byType(ShadowWidget));
    expect(shadowWidget.color, Colors.black);
    expect(shadowWidget.blurRadius, 5);
    expect(shadowWidget.offset, const Offset(2, 2));
  });
}
