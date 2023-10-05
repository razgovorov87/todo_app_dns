import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/generated/assets.gen.dart';

enum TodoStatus {
  created,
  inProgress,
  completed;

  String getTitle() {
    switch (this) {
      case TodoStatus.created:
        return 'Новая';
      case TodoStatus.inProgress:
        return 'В процессе';
      case TodoStatus.completed:
        return 'Выполнено';
    }
  }

  Color getColor() {
    switch (this) {
      case TodoStatus.created:
        return Colors.redAccent;
      case TodoStatus.inProgress:
        return Colors.blueAccent;
      case TodoStatus.completed:
        return Colors.greenAccent;
    }
  }

  SvgPicture getIcon({double? size}) {
    switch (this) {
      case TodoStatus.created:
        return Assets.icons.createdStatusIcon.svg(
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            Colors.redAccent,
            BlendMode.srcIn,
          ),
        );
      case TodoStatus.inProgress:
        return Assets.icons.inProgressStatusIcon.svg(
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            Colors.blueAccent,
            BlendMode.srcIn,
          ),
        );
      case TodoStatus.completed:
        return Assets.icons.completedStatusIcon.svg(
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            Colors.greenAccent,
            BlendMode.srcIn,
          ),
        );
    }
  }
}
