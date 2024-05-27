import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/utils/text_custom.dart';

class DistanciasEvento extends StatelessWidget {
  // Lista ficticia de puntos de control
  final List<LocationData> data = [
    LocationData(
        'Ollantaytambo', 2792), // Altura en metros sobre el nivel del mar
    LocationData('Lares', 3300),
    LocationData('Chupani', 3600),
    LocationData('Huaran', 3100),
    LocationData('Patacancha', 3800),
    LocationData('Willoc', 3300),
    LocationData('Pumamarca', 3000),
    LocationData('Huilloq', 3600),
    LocationData('Incahuasi', 3400),
    LocationData('Piscacucho', 2700),
    LocationData('Aguas Calientes', 2000),
    LocationData('Machu Picchu Pueblo', 2000),
    LocationData('Yucay', 2800),
  ];

   DistanciasEvento({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        elevation: 0.2,
        surfaceTintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.checklist_rtl_sharp,
                    size: 17,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: H2Text(
                      text: "Check Points",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.more_vert,
                        size: 17,
                      ))
                ],
              ),
            ),
            const Divider(
              height: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 300,
              child: ScrollWeb(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  DelayedDisplay(
              delay: const Duration(milliseconds: 400),
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        contentPadding: const EdgeInsets.all(0),
                        minVerticalPadding: 1,
                        minLeadingWidth: 0,
                        leading: const Icon(
                          Icons.flag_circle_sharp,
                          color: Color(0xFF0F7845),
                          size: 17,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H2Text(
                                  text: data[index].name,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                const H2Text(
                                  text: 'ubicacion en lugar de...',
                                  fontSize: 11,
                                ),
                              ],
                            )),
                            Column(
                              children: [
                                H2Text(
                                  text: data[index].altitude.toString(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F7845),
                                ),
                                const H2Text(
                                  text: 'msnm',
                                  fontSize: 10,
                                  color: Color(0xFF0F7845),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationData {
  final String name;
  final int altitude;

  LocationData(this.name, this.altitude);
}
