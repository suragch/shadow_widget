import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shadow_widget/shadow_widget.dart';

void main() {
  group("ShadowWidget", () {
    testGoldens("smoke test", (widgetTester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
        ..addScenario(
          'Rectangle',
          SizedBox(
            width: 200,
            height: 100,
            child: ShadowWidget(
              color: Colors.black,
              blurRadius: 5,
              offset: const Offset(5, 5),
              child: Container(
                width: 200,
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
        );
      await widgetTester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(widgetTester, 'shadow_smoke-test');
    });
  });
}
