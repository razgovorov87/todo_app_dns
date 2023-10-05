import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/domain/bloc/todos/update_todo_bloc.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/model/todo/todo.dart';
import 'package:todo_app/get_it.dart';

import '../../../generated/assets.gen.dart';

@RoutePage()
class TodoInfoDialog extends StatefulWidget {
  const TodoInfoDialog({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  State<TodoInfoDialog> createState() => _TodoInfoDialogState();
}

class _TodoInfoDialogState extends State<TodoInfoDialog> {
  late UpdateTodoBloc _todoBloc;
  late final FToast fToast;

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    _todoBloc = getIt.get<UpdateTodoBloc>(param1: widget.todo.id);
  }

  @override
  void dispose() {
    _todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: _todoBloc,
      child: BlocListener<UpdateTodoBloc, UpdateTodoState>(
        listener: (context, state) => state.whenOrNull<void>(
          error: _showToast,
          success: () {
            context.router.pop();
          },
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: SizedBox(
              width: screenSize.width * 0.82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _InfoWidget(todo: widget.todo),
                  const SizedBox(height: 8),
                  if (widget.todo.status != TodoStatus.completed) _Buttons(todo: widget.todo),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(String msg) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.red.withOpacity(0.15),
      ),
      child: Text(
        msg,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (todo.status == TodoStatus.created)
              Expanded(
                child: _Button(
                  onTap: () {
                    context.read<UpdateTodoBloc>().add(
                          const UpdateTodoEvent.updateStatus(status: TodoStatus.inProgress),
                        );
                  },
                  title: 'Взять в работу',
                  icon: Assets.icons.completedStatusIcon.svg(),
                ),
              ),
            if (todo.status == TodoStatus.inProgress) ...[
              Expanded(
                child: _Button(
                  onTap: () {
                    context.read<UpdateTodoBloc>().add(
                          const UpdateTodoEvent.updateStatus(status: TodoStatus.created),
                        );
                  },
                  title: 'Вернуть в новые',
                  icon: Assets.icons.createdStatusIcon.svg(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Button(
                  onTap: () {
                    context.read<UpdateTodoBloc>().add(
                          const UpdateTodoEvent.updateStatus(status: TodoStatus.completed),
                        );
                  },
                  title: 'Выполнить',
                  icon: Assets.icons.completedStatusIcon.svg(),
                ),
              ),
            ],
          ],
        ),
        if (todo.status == TodoStatus.created) ...[
          const SizedBox(height: 8),
          _Button(
            onTap: () {
              context.read<UpdateTodoBloc>().add(const UpdateTodoEvent.delete());
            },
            title: 'Удалить',
            icon: Assets.icons.trash.svg(),
          ),
        ],
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.onTap,
    required this.title,
    required this.icon,
  });

  final VoidCallback onTap;
  final String title;
  final SvgPicture icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 18,
              child: icon,
            ),
            const SizedBox(width: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                height: 16 / 13,
                color: Color(0xFF1D2041),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: <Widget>[
              Text(
                todo.status.getTitle(),
                style: const TextStyle(
                  fontSize: 13,
                  height: 18 / 13,
                  color: Color(0xFF9494A2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                todo.title,
                style: const TextStyle(
                  fontSize: 20,
                  height: 24 / 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (todo.fullDescription != null)
                Text(
                  todo.fullDescription!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 18 / 13,
                    color: Color(0xFF9494A2),
                  ),
                )
              else
                const Text(
                  'Нет полного описания',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    height: 18 / 13,
                    color: Color(0xFF9494A2),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                _getDate(todo.createdAt),
                style: TextStyle(
                  fontSize: 13,
                  height: 16 / 15,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -25,
          left: 0,
          right: 0,
          child: _Icon(todo: todo),
        ),
      ],
    );
  }

  String _getDate(DateTime createdAt) {
    final DateFormat pattern = DateFormat('dd.MM.yy HH:mm');
    return pattern.format(createdAt);
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(width: 6, color: Colors.white),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: todo.status.getColor().withOpacity(0.15),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          height: 40,
          width: 40,
          child: todo.status.getIcon(size: 32),
        ),
      ),
    );
  }
}
