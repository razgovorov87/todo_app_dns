import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/domain/bloc/todos/create_new_todo_bloc.dart';
import 'package:todo_app/get_it.dart';
import 'package:todo_app/presentation/design/custom_text_field.dart';

import '../../../generated/assets.gen.dart';

@RoutePage()
class CreateNewTodoDialog extends StatefulWidget {
  const CreateNewTodoDialog({super.key});

  @override
  State<CreateNewTodoDialog> createState() => _CreateNewTodoDialogState();
}

class _CreateNewTodoDialogState extends State<CreateNewTodoDialog> {
  late CreateNewTodoBloc _todoBloc;
  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _fullDescController = TextEditingController();

  late final FToast fToast;

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    _todoBloc = getIt.get<CreateNewTodoBloc>();
  }

  @override
  void dispose() {
    _todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final paddingBottom = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider.value(
      value: _todoBloc,
      child: BlocListener<CreateNewTodoBloc, CreateNewTodoState>(
        listener: (context, state) => state.whenOrNull<void>(
          error: _showToast,
          success: () {
            context.router.pop();
          },
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(bottom: paddingBottom),
            child: Center(
              child: SizedBox(
                width: screenSize.width * 0.82,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _BodyWidget(
                      titleController: _titleController,
                      shortDescController: _shortDescController,
                      fullDescController: _fullDescController,
                    ),
                    const SizedBox(height: 8),
                    _Button(
                      onTap: () {
                        _todoBloc.add(
                          CreateNewTodoEvent.create(
                            title: _titleController.text,
                            shortDesc: _shortDescController.text,
                            fullDesc: _fullDescController.text,
                          ),
                        );
                      },
                      title: 'Создать задачу',
                      icon: Assets.icons.completedStatusIcon.svg(),
                    ),
                  ],
                ),
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
        color: Colors.redAccent,
      ),
      child: Text(
        msg,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
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

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    required this.titleController,
    required this.shortDescController,
    required this.fullDescController,
  });

  final TextEditingController titleController;
  final TextEditingController shortDescController;
  final TextEditingController fullDescController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'Создание задачи',
            style: TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: titleController,
            isShowLabel: false,
            hintText: 'Введите название',
            label: 'Название',
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: shortDescController,
            isShowLabel: false,
            isTextArea: true,
            hintText: 'Введите короткое описание',
            label: 'Короткое описание',
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: fullDescController,
            isShowLabel: false,
            isTextArea: true,
            hintText: 'Введите полное описание',
            label: 'Полное описание',
          ),
        ],
      ),
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
