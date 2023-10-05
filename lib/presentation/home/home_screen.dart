import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:todo_app/domain/bloc/todos/todos_cubit.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/model/todo/todo.dart';
import 'package:todo_app/generated/assets.gen.dart';
import 'package:todo_app/get_it.dart';
import 'package:todo_app/presentation/router/router.gr.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TodosMapCubit _todosCubit;

  @override
  void initState() {
    super.initState();
    _todosCubit = getIt.get<TodosMapCubit>();
  }

  @override
  void dispose() {
    _todosCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.of(context).viewPadding;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(CreateNewTodoDialog());
        },
        backgroundColor: const Color(0xFF1D2041),
        child: const Icon(Icons.add, size: 35),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TodosMapCubit, Map<TodoStatus, List<Todo>>>(
          bloc: _todosCubit,
          builder: (context, state) => ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 0, 16, viewPadding.bottom),
            itemCount: state.length,
            itemBuilder: (context, index) {
              final entry = state.entries.elementAt(index);
              return _ListItem(
                status: entry.key,
                todos: entry.value,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.status,
    required this.todos,
  });

  final TodoStatus status;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 6),
        height: 32,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: status.getColor(),
              ),
              alignment: Alignment.center,
              child: Text(
                todos.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              status.getTitle(),
              style: const TextStyle(
                fontSize: 17,
                height: 22 / 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      content: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: todos.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => _TodoWidget(todo: todos[index]),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 6),
      ),
    );
  }
}

class _TodoWidget extends StatelessWidget {
  const _TodoWidget({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(TodoInfoDialog(todo: todo));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              todo.status.getTitle().toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                letterSpacing: -1,
                fontWeight: FontWeight.w600,
                color: todo.status.getColor(),
              ),
            ),
            const Divider(),
            const SizedBox(height: 4),
            SizedBox(
              height: 35,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: todo.status.getColor(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          todo.shortDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.calendar.svg(
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade500,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _getCreatedAtDate(todo.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCreatedAtDate(DateTime createdAt) {
    final format = DateFormat('dd.MM.yy HH:mm');
    return format.format(createdAt);
  }
}
