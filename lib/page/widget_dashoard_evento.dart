
import 'package:flutter/material.dart';
import 'package:inka_challenge/model/provider_config_carrera.dart';
import 'package:inka_challenge/model/provider_v_tabla_participantes.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:provider/provider.dart';

class SelectEvento extends StatefulWidget {
  const SelectEvento({
    super.key,
  });

  @override
  State<SelectEvento> createState() => _SelectEventoState();
}

class Trail {
  final String name;
  final String imagePath;
  final String idEvento;

  Trail({required this.name, required this.imagePath,required this.idEvento });
}

class _SelectEventoState extends State<SelectEvento> {
  Trail? selectedTrail; // Trail seleccionado inicialmente

  List<Trail> trails = [
    Trail(name: 'Andes Race 2024', imagePath: 'assets/img/andeanlodges.png', idEvento: '1l00f2ko7ts1nw6'),
    Trail(name: 'Lachacy Trail 2024', imagePath: 'assets/img/lodge.png', idEvento: '6nh6qb1l1xowf6o'),
  ];
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    final dataEvento  = Provider.of<EventIdProvider>(context);
    final dataProvider = Provider.of<VTablaParticipantesProvider>(context);
    return Card(
      elevation: .2,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal:10, vertical: 15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Trail>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                hintText: 'Selecciona el Evento',
                labelText: 'Evento',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              value: selectedTrail,
              onChanged: (Trail? newValue) async {
                setState(() {
                  selectedTrail = newValue;
                });
                 dataEvento.setIdEvento(newValue!.idEvento);
                 dataProvider.getIdEvento(dataEvento.eventoPref);
              },
              items: trails.map((Trail trail) {
               
                return DropdownMenuItem<Trail>(
                  value: trail,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        trail.imagePath,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                     size.width > 1100 ? H2Text(text: trail.name, color: Colors.black87,fontSize: 12,) : const SizedBox(),
                    ],
                  ),
                );
              }).toList(),
            ),
            (selectedTrail != null) ? 
              Image.asset(
                selectedTrail!.imagePath,
                height: 100,
              ):
              Image.asset(
                'assets/img/llama.png',
                height: 100,
              ),
          ],
        ),
      ),
    );
  }
}
