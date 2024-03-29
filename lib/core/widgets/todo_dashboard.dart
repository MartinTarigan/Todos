import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Todos/core/widgets/dashboard_widget.dart';
import 'package:Todos/feat/cubit/todo_provider.dart';
import 'package:Todos/feat/cubit/todo_state.dart';
import 'package:Todos/feat/data/models/dashboard_item.dart';
import 'package:Todos/feat/global/todo_list.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoCubitProvider, ToDoState>(builder: (context, state) {
      return Column(
        children: [
          Row(
            children: [
              DashboardWidget(
                list: context.read<ToDoCubitProvider>().getTodaysToDo(),
                item: DashboardItem.itemList[0],
              ),
              const Spacer(),
              DashboardWidget(
                list: context.read<ToDoCubitProvider>().getScheduledToDos(),
                item: DashboardItem.itemList[3],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              DashboardWidget(
                list: context.read<ToDoCubitProvider>().getAllToDo(),
                item: DashboardItem.itemList[1],
              ),
              const Spacer(),
              DashboardWidget(
                list: ToDoList.completedToDoList,
                item: DashboardItem.itemList[2],
              ),
            ],
          ),
        ],
      );
    });
  }
}
