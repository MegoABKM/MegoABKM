import 'package:ecommrence/controller/home_controller.dart';
import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:ecommrence/data/model/itemsmodel.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomItems extends GetView<HomeControllerImp> {
  const CustomItems({super.key});

  @override
  Widget build(BuildContext context) {
    // This parent SizedBox controls the height of the horizontal list
    return SizedBox(
      height: context.scaleConfig.scale(180),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.items.length,
          itemBuilder: (context, index) =>
              Items(itemsModel: ItemsModel.fromJson(controller.items[index]))),
    );
  }
}

class Items extends StatelessWidget {
  final ItemsModel itemsModel;
  const Items({super.key, required this.itemsModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Use a Card for elevation and a clean look
      clipBehavior:
          Clip.antiAlias, // This clips the child (Image) to the Card's shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(15)),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: context.scaleConfig.scale(8),
        vertical: context.scaleConfig.scale(10),
      ),
      child: InkWell(
        onTap: () {
          // You might want to implement navigation here
        },
        child: SizedBox(
          width: context.scaleConfig.scale(150),
          child: Stack(
            fit: StackFit.expand, // Makes children fill the Stack
            children: [
              // 1. The Image - now as a background
              Image.network(
                "${AppLink.imagesitems}/${itemsModel.itemsImage}",
                // CRITICAL FIX: Use .cover to maintain aspect ratio and fill space
                fit: BoxFit.cover,
                // Add a loading builder for a better user experience
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                },
                // Add an error builder for robustness
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image_outlined,
                      color: Colors.grey);
                },
              ),

              // 2. The Gradient Overlay for text readability
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: context.scaleConfig.scale(70),
                  decoration: BoxDecoration(
                    // This gradient goes from transparent to semi-opaque black
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.scaleConfig.scale(8),
                    horizontal: context.scaleConfig.scale(12),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    // Use null-aware operator or provide a default value
                    itemsModel.itemsName ?? "Unnamed Product",
                    maxLines: 2, // Prevents long text from overflowing
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: context.scaleConfig.scaleText(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
