import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart'; // For context.appTheme
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/categorymodel.dart';

class NoteCategoryDropdown extends StatelessWidget {
  final HomeController controller;
  final ScaleConfig scale;

  const NoteCategoryDropdown({
    super.key,
    required this.controller,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'note-category-view',
      builder: (controller) {
        // This 'Home' is an internal identifier/default value
        String selectedCategoryValue = 'Home'; // Internal value
        if (controller.selectedNoteCategoryId.value != null) {
          final category = controller.noteCategories.firstWhere(
            (category) =>
                category.id == controller.selectedNoteCategoryId.value,
            // This 'Home' is the default categoryName if not found.
            orElse: () => CategoryModel(id: null, categoryName: "Home"),
          );
          selectedCategoryValue = category.categoryName;
        }

        return Container(
          constraints: BoxConstraints(
            maxWidth: scale.scale(100),
          ),
          padding: EdgeInsets.symmetric(horizontal: scale.scale(6)),
          decoration: BoxDecoration(
            color: context.appTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(scale.scale(6)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategoryValue, // Use the internal value
              icon: Icon(
                FontAwesomeIcons.filter,
                color: context.appTheme.colorScheme.onSecondary,
                size: scale.scale(14),
              ),
              style: TextStyle(
                color: context.appTheme.colorScheme.onSecondary,
                fontSize: scale.scaleText(12),
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
                ...controller.noteCategories.map((category) => DropdownMenuItem(
                      value: category
                          .categoryName, // categoryName acts as the value
                      child: Text(
                        // If category.categoryName needs translation, it should be handled here.
                        // For now, assuming category.categoryName is directly displayable or already translated.
                        category.categoryName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ],
              onChanged: (value) {
                // Logic compares against the non-translated 'Home'
                if (value == 'Home') {
                  controller.filterNotesByCategory(null);
                } else if (value != null) {
                  // Ensure value is not null
                  final category = controller.noteCategories
                      .firstWhere((c) => c.categoryName == value);
                  controller.filterNotesByCategory(category.id);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
