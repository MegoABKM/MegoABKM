import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/categorymodel.dart';

class CategoryDropdown extends StatelessWidget {
  final HomeController controller;
  final ScaleConfig scale;

  const CategoryDropdown({
    super.key,
    required this.controller,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'task-category-view',
      builder: (controller) {
        // This 'Home' is an internal identifier/default value, NOT for direct display as is.
        // The display will come from the DropdownMenuItem's child.
        String selectedCategoryValue = 'Home'; // Internal value
        if (controller.selectedTaskCategoryId.value != null) {
          final category = controller.taskCategories.firstWhere(
            (category) =>
                category.id == controller.selectedTaskCategoryId.value,
            // This 'Home' is the default categoryName if not found.
            orElse: () => CategoryModel(id: null, categoryName: "Home"),
          );
          selectedCategoryValue = category.categoryName;
        }

        return Container(
          constraints: const BoxConstraints(
            maxWidth: 100,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: context.appTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategoryValue, // Use the internal value
              icon: Icon(
                FontAwesomeIcons.filter,
                color:
                    context.appTheme.colorScheme.onSecondary, // Use theme color
                size: 14,
              ),
              style: TextStyle(
                color:
                    context.appTheme.colorScheme.onSecondary, // Use theme color
                fontSize: 12,
              ),
              dropdownColor: context.appTheme.colorScheme.secondary,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: 'Home', // The non-translated value for logic
                  child: Text(
                    'key_home'.tr, // The translated text for display
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...controller.taskCategories.map((category) => DropdownMenuItem(
                      value: category
                          .categoryName, // categoryName acts as the value
                      child: Text(
                        // If category names themselves need translation,
                        // they should also be keys or have a translation mechanism.
                        // For now, assuming category.categoryName is directly displayable or already translated.
                        category.categoryName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ],
              onChanged: (value) {
                // Logic compares against the non-translated 'Home'
                if (value == 'Home') {
                  controller.filterTasksByCategory(null);
                } else if (value != null) {
                  // Ensure value is not null
                  final category = controller.taskCategories
                      .firstWhere((c) => c.categoryName == value);
                  controller.filterTasksByCategory(category.id);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
