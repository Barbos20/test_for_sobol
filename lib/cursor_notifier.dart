import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Line {
  final Offset start;
  final Offset end;

  Line(this.start, this.end);
}

class CursorState {
  final bool isVisible;
  final Offset position;
  final List<Line> lines;

  CursorState(
      {this.isVisible = false,
      this.position = Offset.zero,
      this.lines = const []});

  CursorState copyWith({bool? isVisible, Offset? position, List<Line>? lines}) {
    return CursorState(
      isVisible: isVisible ?? this.isVisible,
      position: position ?? this.position,
      lines: lines ?? this.lines,
    );
  }
}

class CursorNotifier extends StateNotifier<CursorState> {
  CursorNotifier() : super(CursorState());

  void showCursor(Offset position) {
    state = state.copyWith(isVisible: true, position: position);
  }

  void moveCursor(Offset position) {
    state = state.copyWith(position: position);
  }

  void hideCursor() {
    state = state.copyWith(isVisible: false);
  }

  void addLine(Offset start, Offset end) {
    final newLines = List<Line>.from(state.lines)..add(Line(start, end));
    state = state.copyWith(lines: newLines);
  }

  void startLine(Offset startPosition) {
    final newLine = Line(startPosition, startPosition);
    state = state.copyWith(lines: [...state.lines, newLine]);
  }

  void updateLine(Offset newPosition) {
    final List<Line> updatedLines = List.from(state.lines);
    final lastLine = updatedLines.last;
    updatedLines[updatedLines.length - 1] = Line(lastLine.start, newPosition);
    state = state.copyWith(lines: updatedLines);
  }

  void endLine() {}
}
