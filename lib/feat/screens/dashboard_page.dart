import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:Todos/core/constant/typography.dart';
import 'package:Todos/core/theme/base_color.dart';
import 'package:Todos/core/widgets/task_container.dart';
import 'package:Todos/feat/cubit/interaction.dart';
import 'package:Todos/feat/cubit/todo_provider.dart';
import 'package:Todos/feat/cubit/todo_state.dart';
import 'package:Todos/feat/data/models/dashboard_item.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = "/dashboard_page";
  final Item item;
  const DashboardPage({super.key, required this.item});

  @override
  State<DashboardPage> createState() => _DashbordPageState();
}

class _DashbordPageState extends State<DashboardPage> {
  bool showCalendarView = false;

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    List<DateTime> dateRange = context.read<ToDoCubitProvider>().getDateRange();
    bool isScheduledPage = widget.item.itemName == "Scheduled";
    bool isCompletedPage = widget.item.itemName == "Completed";
    var quickViewtTodoList = [];
    var calendarViewTodoList = [];
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        calendarViewTodoList = context
            .read<ToDoCubitProvider>()
            .getToDosByDate(7 ~/ 2, currentDate);
        quickViewtTodoList = context
            .read<ToDoCubitProvider>()
            .updateDashboardToDoList(widget.item.itemName);
      },
    );
    return BlocBuilder<ToDoCubitProvider, ToDoState>(
      builder: (context, state) {
        if (state is ToDoListUpdated) {
          calendarViewTodoList = context
              .read<ToDoCubitProvider>()
              .updateDashboardToDoList(widget.item.itemName);
          quickViewtTodoList = context
              .read<ToDoCubitProvider>()
              .updateDashboardToDoList(widget.item.itemName);
        }

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  color: BaseColors.purple,
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: MediaQuery.of(context).padding.top,
                    bottom: 30,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          context
                              .read<InteractionCubit>()
                              .toggleButton(selectedDateIndex: 7 ~/ 2);
                        },
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: BaseColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            widget.item.icon,
                            color: BaseColors.white,
                            size: 100,
                          ),
                          Text(
                            widget.item.itemName,
                            style: Font.heading1,
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 8, top: 10, bottom: 10),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3.5 - 30,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: BaseColors.neutral,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      isScheduledPage
                          ? SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => showCalendarView = false,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: BaseColors.primaryBlue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Quick View',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        showCalendarView = true;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: BaseColors.red,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Calendar View',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      showCalendarView
                          ? Expanded(child:
                              BlocBuilder<InteractionCubit, InteractionState>(
                                  builder: (context, state) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: double.infinity,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 7,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 10),
                                      itemBuilder: (context, index) {
                                        final date = dateRange[index];
                                        int selectedIndex = 0;
                                        if (state is InitDataState) {
                                          selectedIndex =
                                              state.selectedDateIndex;
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<InteractionCubit>()
                                                .toggleButton(
                                                    selectedDateIndex: index);
                                            calendarViewTodoList = context
                                                .read<ToDoCubitProvider>()
                                                .getToDosByDate(
                                                    index, currentDate);
                                          },
                                          child: Container(
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: index == selectedIndex
                                                  ? BaseColors.primaryBlue
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: BaseColors.secondaryGrey,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat('EEE')
                                                      .format(date),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        index == selectedIndex
                                                            ? BaseColors.white
                                                            : BaseColors.black,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('d').format(date),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        index == selectedIndex
                                                            ? BaseColors.white
                                                            : BaseColors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: BlocBuilder<ToDoCubitProvider,
                                        ToDoState>(
                                      builder: (context, state) {
                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                          itemCount:
                                              calendarViewTodoList.length,
                                          itemBuilder: (context, index) {
                                            final todo =
                                                calendarViewTodoList[index];
                                            return ToDoContainer(
                                              todo: todo,
                                              isCompletedToDo: isCompletedPage,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }))
                          : Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: quickViewtTodoList.length,
                                itemBuilder: (context, index) {
                                  final todo = quickViewtTodoList[index];
                                  String date =
                                      todo.date.toString().split(" - ")[0];
                                  DateTime dateTime =
                                      DateFormat("dd/MM/yyyy").parse(date);
                                  date = DateFormat("dd MMM yyyy")
                                      .format(dateTime);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isScheduledPage
                                          ? Text(date)
                                          : Container(),
                                      ToDoContainer(
                                        todo: todo,
                                        isScheduledToDo:
                                            widget.item.itemName == "Scheduled",
                                        isCompletedToDo: isCompletedPage,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
