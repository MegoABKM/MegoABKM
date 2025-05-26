import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/controller/notes/noteview_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart'; // For categories
// Removed unused ScaleConfig import if not directly used, extensions.dart handles it.

class ViewNote extends StatelessWidget {
  const ViewNote({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteviewController controller = Get.put(NoteviewController());
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: colorScheme.onSurfaceVariant),
          onPressed: () {
            controller.updateData(); // Save on back press
            Get.offAllNamed(AppRoute.home);
          },
        ),
        title: GetBuilder<NoteviewController>(
          builder: (ctrl) => TextField(
            controller: ctrl.insideTitleField,
            readOnly: ctrl
                .isDrawingMode, // Title not editable in drawing view/edit mode
            style: TextStyle(
              fontSize: scale.scaleText(
                  22), // Slightly smaller than create for appbar feel
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText:
                  "key_view_note_title_hint".tr, // New Key (replaces 173.tr)
              border: InputBorder.none,
              counterText: "",
              hintStyle: TextStyle(
                fontSize: scale.scaleText(22),
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
            onChanged: ctrl.saveTitle,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        actions: [
          GetBuilder<NoteviewController>(
            builder: (ctrl) => IconButton(
              icon: Icon(
                ctrl.isDrawingMode
                    ? Icons.text_fields_outlined
                    : Icons.draw_outlined,
                color: colorScheme.primary,
                size: scale.scale(26),
              ),
              tooltip: ctrl.isDrawingMode
                  ? "key_drawing_mode_on_tooltip"
                      .tr // New Key "Switch to Text Mode"
                  : "key_drawing_mode_off_tooltip"
                      .tr, // New Key "Switch to Drawing/View Drawing"
              onPressed: () {
                ctrl.toggleDrawingMode();
                // If switching from drawing edit to text view, and canvas has changes, save.
                if (!ctrl.isDrawingMode &&
                    ctrl.signatureController.isNotEmpty) {
                  ctrl.updateData();
                }
              },
            ),
          ),
          // Future actions: Delete, Share
          // IconButton(icon: Icon(Icons.delete_outline, color: colorScheme.error), onPressed: () {/* ... */}),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<NoteviewController>(
          builder: (controller) {
            if (controller.note == null) {
              return Center(
                child: Text(
                  "key_note_not_found_message".tr, // New Key (replaces 170.tr)
                  style: TextStyle(
                    fontSize: scale.scaleText(18),
                    color: colorScheme.error,
                  ),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // Changed to SingleChildScrollView for independent scrolling of content
                    padding: EdgeInsets.symmetric(
                        horizontal: scale.scale(18), vertical: scale.scale(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCategorySelector(
                            context, controller, Get.find<HomeController>()),
                        SizedBox(height: scale.scale(16)),

                        if (!controller.isDrawingMode)
                          _buildTextContentView(context, controller)
                        else // In drawing mode (viewing or editing drawing)
                          _buildDrawingViewOrEditCanvas(context, controller),

                        // Display existing drawing below text if not in drawing mode and drawing exists
                        if (!controller.isDrawingMode &&
                            controller.drawingBytes != null &&
                            controller.drawingBytes!.isNotEmpty)
                          _buildStaticDrawingDisplay(context, controller),

                        SizedBox(
                            height: scale.scale(controller.isDrawingMode
                                ? 20
                                : 80)), // Adjust bottom space
                      ],
                    ),
                  ),
                ),
                if (controller
                    .isDrawingMode) // Show drawing tools only in drawing mode
                  _buildDrawingModeBottomBar(context, controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context,
      NoteviewController controller, HomeController homeController) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    final categories = [
      DropdownMenuItem<int?>(
        value: null,
        child: Text("key_no_category_option".tr,
            style: TextStyle(fontSize: scale.scaleText(14))),
      ),
      ...homeController.noteCategories.map((category) {
        return DropdownMenuItem<int?>(
          value: category.id,
          child: Text(category.categoryName,
              style: TextStyle(fontSize: scale.scaleText(14))),
        );
      }).toList(),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: scale.scale(12), vertical: scale.scale(4)),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(scale.scale(20)), // Pill shape
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: controller.selectedCategoryId,
          items: categories,
          onChanged: (int? newValue) {
            controller.selectedCategoryId = newValue;
            controller.updateData(); // Save category change
          },
          icon:
              Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
          isExpanded: true,
          style: TextStyle(
            fontSize: scale.scaleText(14),
            color: colorScheme.onSurface,
          ),
          dropdownColor: theme.cardColor,
          hint: Text(
            "key_select_category_hint".tr, // Reusing key from create
            style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: scale.scaleText(14)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContentView(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    // Hero tag should be unique and stable for the note
    String heroTag =
        controller.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    return Hero(
      tag: heroTag,
      child: Material(
        // Wrap TextField in Material for Hero animation
        type: MaterialType.transparency,
        child: TextField(
          controller: controller.insideTextField,
          maxLines: null,
          minLines: 10, // Adjust as needed
          readOnly: controller.isDrawingMode,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            fontSize: scale.scaleText(16),
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: "key_note_content_hint".tr, // Reusing key
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: scale.scaleText(16),
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          onChanged: controller.saveContent,
        ),
      ),
    );
  }

  Widget _buildStaticDrawingDisplay(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    return Padding(
      padding: EdgeInsets.only(top: scale.scale(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("key_view_drawing_label".tr, // New Key "Drawing:"
              style: TextStyle(
                  fontSize: scale.scaleText(14),
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant)),
          SizedBox(height: scale.scale(8)),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(scale.scale(12)),
                border:
                    Border.all(color: colorScheme.outline.withOpacity(0.5))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(scale.scale(11)),
              child: Image.memory(
                controller.drawingBytes!,
                height: scale.scale(300),
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                  "key_error_loading_drawing_message".tr, // New Key
                  style: TextStyle(
                      color: colorScheme.error, fontSize: scale.scaleText(14)),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingViewOrEditCanvas(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    // If there's an existing drawing and we are in drawing mode,
    // but the signature controller is empty, it means we are viewing an existing drawing.
    // However, the requirement is more like "edit drawing" mode.
    // So, the signature canvas is always active for editing in drawing mode.
    // The initial points would need to be loaded if you want to edit existing drawings.
    // For simplicity, entering drawing mode clears the canvas for new input or to overlay on existing.
    // (The controller logic handles loading initial drawingBytes to display)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: scale.scale(8)),
          child: Text(
            "key_drawing_canvas_label".tr, // Reusing key
            style: TextStyle(
                fontSize: scale.scaleText(14),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant),
          ),
        ),
        Container(
          height: scale.scale(350),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? colorScheme.surfaceVariant
                : Colors.white,
            borderRadius: BorderRadius.circular(scale.scale(12)),
            border: Border.all(
                color: colorScheme.outline.withOpacity(0.5), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(scale.scale(11)),
            child: Signature(
              controller: controller.signatureController,
              backgroundColor: theme.brightness == Brightness.dark
                  ? colorScheme.surfaceVariant
                  : Colors.white,
              // To load existing drawing into canvas for editing:
              // This is complex as SignatureController takes points, not image bytes.
              // For now, it's a fresh canvas when isDrawingMode is true.
              // The displayed `drawingBytes` (if any) acts as a visual reference underneath.
            ),
          ),
        ),
        // Display current drawingBytes as a background if available and canvas is clear, for reference
        if (controller.drawingBytes != null &&
            controller.signatureController.isEmpty)
          Opacity(
            opacity: 0.3, // So it's clear it's a reference
            child: Padding(
              padding: EdgeInsets.only(top: scale.scale(8.0)),
              child: Image.memory(
                controller.drawingBytes!,
                height: scale.scale(350), // Match canvas height
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDrawingModeBottomBar(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: scale.scale(8), horizontal: scale.scale(16)),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.undo, color: colorScheme.primary),
            tooltip: "key_drawing_tools_undo".tr,
            onPressed: () {
              if (controller.signatureController.isNotEmpty) {
                controller.signatureController.undo();
                controller
                    .update(); // To reflect change if not automatically updating
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colorScheme.error),
            tooltip: "key_drawing_tools_clear".tr,
            onPressed: () {
              controller.signatureController.clear();
              controller.update();
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.check_circle_outline, color: colorScheme.primary),
            label: Text("key_drawing_tools_done".tr, // New Key "Done"
                style: TextStyle(
                    color: colorScheme.primary, fontWeight: FontWeight.bold)),
            onPressed: () {
              // Save the drawing and switch out of drawing mode
              controller
                  .updateData(); // This will capture the drawing from signatureController
              controller.isDrawingMode = false;
              controller.update(); // Refresh UI
            },
          ),
        ],
      ),
    );
  }
}
