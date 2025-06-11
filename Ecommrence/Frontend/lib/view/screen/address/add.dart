import 'package:ecommrence/controller/address/addaddress_controller.dart';
import 'package:ecommrence/core/class/handlingdataview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AddMap extends StatelessWidget {
  const AddMap({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddAddressController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: GetBuilder<AddAddressController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 500,
                width: Get.width,
                child: FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(33.5138, 36.2765),
                    initialZoom: 15,
                    onTap: (tapPosition, point) {
                      controller.setMarkerPosition(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    if (controller.markerPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: controller.markerPosition!,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Text(
                controller.markerPosition != null
                    ? 'Marker Position: ${controller.markerPosition!.latitude}, ${controller.markerPosition!.longitude}'
                    : 'Getting current location...',
                textAlign: TextAlign.center,
              ),
              Text(
                controller.streetName != null && controller.cityName != null
                    ? 'Street: ${controller.streetName}, City: ${controller.cityName}'
                    : 'Fetching address...',
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: controller.nameLocation,
                  decoration: const InputDecoration(hintText: "Name Location"),
                ),
              ),
              Handlingdataview(
                statusRequest: controller.statusRequest,
                widget: TextButton(
                  onPressed: () {
                    controller.addData();
                  },
                  child: const Text("Save location"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
