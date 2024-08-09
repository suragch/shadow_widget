import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shadow_widget/shadow_widget.dart';

class ShadowDemo extends StatefulWidget {
  const ShadowDemo({
    super.key,
  });

  static const color = Color(0xFF8E8E93);
  static const radius = 10.0;
  static const x = 10.0;
  static const y = 10.0;

  @override
  State<ShadowDemo> createState() => _ShadowDemoState();
}

class _ShadowDemoState extends State<ShadowDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    ShadowWidget(
                      offset: _offset,
                      color: _color,
                      blurRadius: _blurRadius,
                      child: _widgetGettingShadow(),
                    ),
                    const SizedBox(height: 20),
                    _segmentedControl(),
                    const SizedBox(height: 20),
                    const Text('Offset'),
                    _offsetControl(),
                    const Text('Blur radius'),
                    _blurControl(),
                    const Text('Color'),
                    _colorControl(),
                    const Text('Opacity'),
                    _opacityControl(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late Widget _currentWidget = rectangle;

  final rectangle = Center(
    child: Container(
      height: 100,
      width: 200,
      color: Colors.blue,
    ),
  );

  final star = const Star(
    points: 5,
    strokeLineWidth: 5,
    strokeColor: Colors.blue,
  );

  final image = Image.asset(
    'assets/dash_hello.png',
    fit: BoxFit.contain,
  );

  Widget _widgetGettingShadow() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: _currentWidget,
    );
  }

  Set<int> _selectedSegment = {0};
  Widget _segmentedControl() {
    return SegmentedButton(
      segments: const [
        ButtonSegment(value: 0, label: Text('Box')),
        ButtonSegment(value: 1, label: Text('Star')),
        ButtonSegment(value: 2, label: Text('Image')),
      ],
      showSelectedIcon: false,
      selected: _selectedSegment,
      onSelectionChanged: (value) {
        setState(
          () {
            _selectedSegment = value;
            _currentWidget = _currentWidget = value.first == 0
                ? rectangle
                : value.first == 1
                    ? star
                    : image;
          },
        );
      },
    );
  }

  double _offsetSlider = 0.0;
  Offset _offset = Offset.zero;

  Widget _offsetControl() {
    return Slider(
      value: _offsetSlider,
      min: 0.0,
      max: 2 * pi,
      onChanged: (newValue) {
        setState(() {
          _offsetSlider = newValue;
          double distance = -20 * newValue / (2 * pi);
          _offset = Offset(distance * cos(newValue), distance * sin(newValue));
        });
      },
    );
  }

  double _blurRadius = 0.0;
  Widget _blurControl() {
    return Slider(
      value: _blurRadius,
      min: 0.0,
      max: 20.0,
      onChanged: (newValue) {
        setState(() {
          _blurRadius = newValue;
        });
      },
    );
  }

  Color _color = Colors.black;
  double _colorSliderValue = 0.0;
  Widget _colorControl() {
    return Slider(
      value: _colorSliderValue,
      min: 0.0,
      max: 1.0,
      onChanged: (newValue) {
        setState(() {
          _colorSliderValue = newValue;
          if (newValue < 0.25) {
            _color = Color.lerp(Colors.black, Colors.red, newValue * 4)!;
          } else if (newValue < 0.5) {
            _color = Color.lerp(Colors.red, Colors.blue, (newValue - 0.25) * 4)!;
          } else if (newValue < 0.75) {
            _color = Color.lerp(Colors.blue, Colors.green, (newValue - 0.5) * 4)!;
          } else {
            _color = Color.lerp(Colors.green, Colors.purple, (newValue - 0.75) * 4)!;
          }
          _color = _color.withOpacity(_opacity);
        });
      },
    );
  }

  double _opacity = 1.0;
  Widget _opacityControl() {
    return Slider(
      value: _opacity,
      min: 0.0,
      max: 1.0,
      onChanged: (newValue) {
        setState(() {
          _opacity = newValue;
          _color = _color.withOpacity(newValue);
        });
      },
    );
  }
}

class Star extends StatelessWidget {
  final int points;
  final double strokeLineWidth;
  final Color strokeColor;

  const Star({
    super.key,
    required this.points,
    required this.strokeLineWidth,
    required this.strokeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _StarPainter(
        points: points,
        strokeLineWidth: strokeLineWidth,
        strokeColor: strokeColor,
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final int points;
  final double strokeLineWidth;
  final Color strokeColor;

  _StarPainter({
    required this.points,
    required this.strokeLineWidth,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    const starExtrusion = 0.5;
    final angle = pi / points;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    for (int i = 0; i < 2 * points; i++) {
      final rotation = i * angle;
      final position = Offset(
        center.dx + cos(rotation) * radius * (i % 2 == 0 ? 1 : starExtrusion),
        center.dy + sin(rotation) * radius * (i % 2 == 0 ? 1 : starExtrusion),
      );

      if (i == 0) {
        path.moveTo(position.dx, position.dy);
      } else {
        path.lineTo(position.dx, position.dy);
      }
    }

    path.close();

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = strokeColor
      ..strokeWidth = strokeLineWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.strokeLineWidth != strokeLineWidth ||
      oldDelegate.strokeColor != strokeColor;
}
