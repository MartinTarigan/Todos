import 'package:Todos/feat/cubit/interaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Todos/core/constant/typography.dart';
import 'package:Todos/core/theme/base_color.dart';
import 'package:Todos/feat/cubit/todo_provider.dart';
import 'package:Todos/feat/cubit/todo_state.dart';
import 'package:Todos/feat/data/models/todo.dart';
import 'package:Todos/feat/screens/edit_todo.dart';

class ToDoContainer extends StatefulWidget {
  final ToDo todo;
  final bool isScheduledToDo;
  final bool isCompletedToDo;

  const ToDoContainer({
    Key? key,
    required this.todo,
    this.isScheduledToDo = false,
    this.isCompletedToDo = false,
  }) : super(key: key);

  @override
  State<ToDoContainer> createState() => _ToDoContainerState();
}

class _ToDoContainerState extends State<ToDoContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoCubitProvider, ToDoState>(
      builder: (context, state) {
        return BlocBuilder<InteractionCubit, InteractionState>(
            builder: (context, _) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: BaseColors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    widget.todo.title,
                                    style: Font.tertiaryBodyLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                widget.isScheduledToDo
                                    ? Container()
                                    : Text(widget.todo.date ?? ""),
                                Text(context
                                    .read<ToDoCubitProvider>()
                                    .getCategory(widget.todo.categoryID)
                                    .title),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                context
                                    .read<ToDoCubitProvider>()
                                    .markAsCompleted(widget.todo);
                                setState(() {
                                  
                                });
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );
                                context.read<ToDoCubitProvider>().deleteToDo(
                                    widget.todo, widget.isCompletedToDo);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: BaseColors.purple,
                                    width: 2.5,
                                  ),
                                  color: widget.todo.isChecked
                                      ? BaseColors.purple
                                      : BaseColors.white,
                                ),
                                child: Icon(
                                  widget.todo.isChecked ? Icons.check : null,
                                  color: BaseColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    EditToDoPage.routeName,
                                    arguments: widget.todo,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 40),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.withOpacity(0.8)),
                                  child: Text(
                                    "View",
                                    style: Font.primaryBodyMedium,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context
                                    .read<ToDoCubitProvider>()
                                    .deleteToDo(
                                        widget.todo, widget.isCompletedToDo),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: BaseColors.red,
                                  ),
                                  child: Text(
                                    "Delete",
                                    style: Font.primaryBodyMedium,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -3.5,
                bottom: 25,
                child: Container(
                  width: 6,
                  height: 36,
                  decoration: BoxDecoration(
                    color: BaseColors.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
