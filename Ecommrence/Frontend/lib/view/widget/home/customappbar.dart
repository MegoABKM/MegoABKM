import 'package:ecommrence/core/constant/utils/extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String textAppBar;
  final TextEditingController searchController;
  final void Function()? onPressedSearch;
  final void Function()? onPressedFavorite;
  final void Function(String)? onChanged;

  const CustomAppBar(
      {super.key,
      required this.textAppBar,
      this.onPressedSearch,
      required this.onPressedFavorite,
      required this.searchController,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.scaleConfig.scale(10)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: onChanged,
              controller: searchController,
              decoration: InputDecoration(
                hintText: textAppBar,
                hintStyle:
                    TextStyle(fontSize: context.scaleConfig.scaleText(18)),
                prefixIcon: IconButton(
                    onPressed: onPressedSearch, icon: const Icon(Icons.search)),
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(context.scaleConfig.scale(20)),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(
            width: context.scaleConfig.scale(10),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(context.scaleConfig.scale(20)),
              color: Colors.grey[200],
            ),
            width: context.scaleConfig.scale(60),
            padding:
                EdgeInsets.symmetric(vertical: context.scaleConfig.scale(8)),
            child: IconButton(
              onPressed: onPressedFavorite,
              icon: Icon(
                Icons.favorite_outline,
                size: context.scaleConfig.scale(35),
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
