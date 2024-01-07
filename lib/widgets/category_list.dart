import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracker/utils/icons_list.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = '';
  List<Map<String, dynamic>> categoryList = [];

  final scrollController = ScrollController();
  var appIcons = AppIcons();
  var addCat = {
    'name': 'All',
    'icon': FontAwesomeIcons.shop,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryList = appIcons.homeExpensesCategories;
      categoryList.insert(0, addCat);
    });
  }

  // scrollToSelectedMonth() {
  //   final selectedMonthIndex = months.indexOf(currentMonth);
  //   if (selectedMonthIndex != -1) {
  //     final scrollOffset = (selectedMonthIndex * 100.0) - 170;
  //     scrollController.animateTo(scrollOffset,
  //         duration: Duration(milliseconds: 500), curve: Curves.ease);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
          controller: scrollController,
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var data = categoryList[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentCategory = data['name'];
                  widget.onChanged(data['name']);
                });
              },
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: currentCategory == data['name']
                        ? Colors.deepPurple
                        : Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Row(
                  children: [
                    Icon(
                      data['icon'],
                      size: 15,
                      color: currentCategory == data['name']
                          ? Colors.white
                          : Colors.purple,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      data['name'],
                      style: TextStyle(
                          color: currentCategory == data['name']
                              ? Colors.white
                              : Colors.purple),
                    ),
                  ],
                )),
              ),
            );
          }),
    );
  }
}
