import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommrence/data/datasource/linkapi.dart';
import 'package:flutter/material.dart';

class CartItems extends StatelessWidget {
  final String cartImage;
  final String cartName;
  final String cartPrice;
  final String count;
  final void Function()? pluscountitem;
  final void Function()? minuscountitem;

  const CartItems(
      {super.key,
      required this.cartImage,
      required this.cartName,
      required this.cartPrice,
      required this.count,
      this.pluscountitem,
      this.minuscountitem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          imageUrl: "${AppLink.imagesitems}/$cartImage",
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text(cartName),
                        subtitle: Text(
                          "$cartPrice\$",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              child: IconButton(
                                  onPressed: pluscountitem,
                                  icon: const Icon(Icons.add)),
                            ),
                            Container(
                              height: 30,
                              child: Text(
                                count,
                                style: TextStyle(fontFamily: "sams"),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: IconButton(
                                  onPressed: minuscountitem,
                                  icon: const Icon(Icons.remove)),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
