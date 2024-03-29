import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Todos/core/constant/assets.dart';
import 'package:Todos/core/constant/typography.dart';
import 'package:Todos/core/theme/base_color.dart';
import 'package:Todos/core/widgets/fab_todo.dart';
import 'package:Todos/core/widgets/task_container.dart';
import 'package:Todos/feat/cubit/todo_provider.dart';
import 'package:Todos/feat/cubit/todo_state.dart';
import 'package:Todos/feat/data/models/todo.dart';
import 'package:Todos/feat/screens/add_todo_page.dart';
import 'package:Todos/feat/screens/category_todo_list.dart';

class CategoryPage extends StatelessWidget {
  static const routeName = "/category_page";
  final Category category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToDoCubitProvider>().updateUIForCategory(category);
    });
    return BlocBuilder<ToDoCubitProvider, ToDoState>(
      builder: (context, state) {
        var todaysToDos =
            context.read<ToDoCubitProvider>().getCategoryTodaysToDos(category);
        return Scaffold(
          backgroundColor: BaseColors.neutral,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: category.color,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 160,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5.0, sigmaY: 5.0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.3),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_back_ios,
                                            color: BaseColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      category.title,
                                      style: Font.primaryBodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.list_alt_rounded,
                        size: 150,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          TotalToDoCategory(
                        category: category,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(
                        milliseconds: 300,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: BaseColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BaseColors.primaryBlue,
                              ),
                              child: const Icon(
                                Icons.folder_rounded,
                                color: BaseColors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total ToDo",
                                  style: Font.secondaryBodyMedium,
                                ),
                                Text(
                                  category.todoList.length.toString(),
                                  style: Font.tertiaryBodyMedium,
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: BaseColors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Today ToDo",
                  style: Font.heading2,
                ),
                todaysToDos.isEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.emptyList,
                                scale: 6,
                              ),
                              Text(
                                "Your ToDo List is Empty",
                                style: Font.heading3,
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: todaysToDos
                              .where((todo) => !todo.isCompleted)
                              .length,
                          itemBuilder: (context, index) {
                            todaysToDos = todaysToDos
                                .where((todo) => !todo.isCompleted)
                                .toList();
                            return ToDoContainer(
                              todo: todaysToDos[index],
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FABToDo(
            buttonName: "Add New ToDo",
            onTap: () {
              Navigator.pushNamed(
                context,
                AddToDoPage.routeName,
                arguments: category,
              );
            },
          ),
        );
      },
    );
  }
}
