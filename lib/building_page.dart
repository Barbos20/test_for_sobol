import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_for_sobol/cursor_notifier.dart';
import 'package:test_for_sobol/main.dart';

class BuildingPage extends ConsumerWidget {
  const BuildingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onPanDown: (details) {
          ref.read(cursorProvider.notifier).startLine(details.localPosition);
          ref.read(cursorProvider.notifier).showCursor(details.localPosition);
        },
        onPanUpdate: (details) {
          ref.read(cursorProvider.notifier).updateLine(details.localPosition);
          ref.read(cursorProvider.notifier).moveCursor(details.localPosition);
        },
        onPanEnd: (details) {
          ref.read(cursorProvider.notifier).endLine();
          ref.read(cursorProvider.notifier).hideCursor();
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                image: const DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: CustomPaint(
                painter: LinePainter(cursorState.lines),
              ),
            ),
            if (cursorState.isVisible)
              Positioned(
                left: cursorState.position.dx - 20,
                top: cursorState.position.dy - 20,
                child: Image.asset(
                  'assets/cursor.png',
                  width: 40,
                  height: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Line> lines;

  LinePainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;
    for (var line in lines) {
      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
