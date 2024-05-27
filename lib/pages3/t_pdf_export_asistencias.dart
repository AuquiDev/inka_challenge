// ignore_for_file: use_build_context_synchronously, avoid_web_libraries_in_flutter

// import 'dart:io';
// import 'dart:html' as html;
import 'dart:io';
import 'package:inka_challenge/model/model_distancias_ar.dart';
import 'package:inka_challenge/model/model_runners_ar.dart';
import 'package:inka_challenge/provider/provider_t_distancias_ar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class PDFExportAsistencia extends StatefulWidget {
  const PDFExportAsistencia(
      {super.key, required this.listaCorrdores, required this.tituloEmpleado});
  final List<TRunnersModel> listaCorrdores;
  final String tituloEmpleado;
  @override
  State<PDFExportAsistencia> createState() => _PDFExportAsistenciaState();
}

class _PDFExportAsistenciaState extends State<PDFExportAsistencia> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final listaProveedor = Provider.of<TDistanciasArProvider>(context).listAsistencia;
    return isSaving
        ? const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ))
        : IconButton(
            icon: const Icon(
              Icons.print_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {
              setState(() {
                isSaving = true;
              });
              // Simulación de guardado con un retraso de 2 segundos
              await Future.delayed(const Duration(seconds: 2));

              //PDF Generate
              ByteData byteData =
                  await rootBundle.load('assets/img/logo_ar_red.png');
              Uint8List imagenBytes = byteData.buffer.asUint8List();

              //PDF RUNNER
              ByteData byteData1 =
                  await rootBundle.load('assets/img/runner2.png');
              Uint8List imgRunnner = byteData1.buffer.asUint8List();

              pw.Document pdf = pw.Document();

              //PAGINA lista de compras
              pdf.addPage(pw.MultiPage(
                margin: const pw.EdgeInsets.all(20),
                maxPages: 200,
                // orientation: pw.PageOrientation.landscape, //ORIENTACION DE LA PAGINA 
                pageFormat: PdfPageFormat.a4.copyWith(
                    marginTop: 0, marginBottom: 30), // Aplica los márgenes
                build: (pw.Context context) {
                  var textStyle = pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    fontBoldItalic: pw.Font.times(),
                    color: const PdfColor.fromInt(
                  0xFF9C0505)
                  );
                  const edgeInsets =
                      pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2);
                  return [
                    pw.Column(
                      children: [
                        titlePages(imagenBytes, imgRunnner),
                        pw.Table(
                          // border: pw.TableBorder.all(
                          //     color: grisbordertable, width: .1),
                          children: [
                            pw.TableRow(
                              // decoration: const pw.BoxDecoration(color: grisbordertable),
                              children: [
                                pw.Text('#',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                                pw.Text('NOMBRE',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                              
                                pw.Text('DORSAL',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                                pw.Text('PAÍS',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                                pw.Text('GENERO',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                                pw.Text('TALLA',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                                  pw.Text('DISTANCIA',
                                    style: textStyle,
                                    textAlign: pw.TextAlign.center),
                              ],
                            ),
                            
                            if(widget.listaCorrdores.isNotEmpty)
                            ...widget.listaCorrdores.map((e) {
                             
                              TDistanciasModel obtenerDetalleTrabajo(
                                  String idTrabajo) {
                                for (var data in listaProveedor) {
                                  if (data.id == e.idDistancia) {
                                    return data;
                                  }
                                }
                                return TDistanciasModel(
                                  distancias: '',
                                  descripcion: '',
                                  estatus: true,
                                  color: '',
                                );
                              }

                              final v = obtenerDetalleTrabajo(e.idDistancia);

                              final index = widget.listaCorrdores.indexOf(e);

                              int contador = index + 1;
                              PdfColor color = index % 2 == 0
                                  ? const PdfColor.fromInt(0xFFFFFFFF) // Blanco
                                  : const PdfColor.fromInt(0xFFF0F0F0); // Gris claro
                              return pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                decoration: pw.BoxDecoration(color: color),
                                children: [
                                  pw.Container(
                                    width: 19,
                                    padding: edgeInsets,
                                    child: pw.Text(contador.toString(),
                                        style: tableTextStyle(),
                                        textAlign: pw.TextAlign.center),
                                  ),
                                  pw.Container(
                                    // width: 110,
                                    padding: edgeInsets,
                                    child: pw.Text('${e.nombre} ${e.apellidos}',
                                        style: tableTextStyle(),
                                        textAlign: pw.TextAlign.start),
                                  ),
                                  pw.Container(
                                    padding: edgeInsets,
                                    width: 40.0,
                                    child: pw.Text(e.dorsal,
                                        style: tableTextStyle(),
                                        textAlign: pw.TextAlign.center),
                                  ),
                                  
                                  pw.Container(
                                    padding: edgeInsets,
                                    // width: 40.0,
                                    child: pw.Text(e.pais,
                                        style: tableTextStyle(),
                                        textAlign: pw.TextAlign.center),
                                  ),
                                   pw.Container(
                                    padding: edgeInsets,
                                    // width: 40.0,
                                    child: pw.Text(e.genero,
                                        style: tableTextStyle(),
                                        textAlign: pw.TextAlign.center),
                                  ),
                                   pw.Container(
                                    padding: edgeInsets,
                                    // width: 40.0,
                                    child: pw.Text(e.tallaDePolo,
                                        style: pw.TextStyle(
                                              fontSize: 8,
                                              fontWeight: pw.FontWeight.normal,
                                              color: (e.estado)
                                                  ? const PdfColor.fromInt(
                                                      0xFF0D0D0D)
                                                  : const PdfColor.fromInt(
                                                      0xFFBA2312),
                                            ),
                                        textAlign: pw.TextAlign.center),
                                  ),
                                
                                  pw.Container(
                                    width: 50,
                                    padding: edgeInsets,
                                    child: pw.Center(
                                      child: pw.Text(v.distancias,
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                            fontBoldItalic: pw.Font.timesBoldItalic(),
                                            color: PdfColor.fromInt(
                                                int.parse(v.color, radix: 16)),
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                  ),
                                
                                ],
                              );
                            }),
                          ],
                        ),
                      ],
                    )
                  ];
                },

                footer: (context) {
                  return fooTerPDF();
                },
              ));

              // MOVIL
              Uint8List bytes = await pdf.save();
              Directory directory = await getApplicationDocumentsDirectory();
              File filePdf = File(
                  "${directory.path}/lista corredores ${widget.tituloEmpleado}.pdf");
              filePdf.writeAsBytes(bytes);
              OpenFilex.open(filePdf.path);

              // //WEB
              //     final pdfBytes = Uint8List.fromList(await pdf.save());
              // final blob = html.Blob([pdfBytes]);
              // final url = html.Url.createObjectUrlFromBlob(blob);

              // html.AnchorElement(href: url)
              //   ..setAttribute("download", "asistencias.pdf")
              //   ..click();

              // html.Url.revokeObjectUrl(url);

              // print(directory.path);
              // print(bytes);
              // Mostrar un mensaje de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Archivo PDF exportado con éxito'),
                ),
              );
              setState(() {
                isSaving = false;
              });
            },
          );
  }

  pw.TextStyle tableTextStyle() {
    return pw.TextStyle(
      fontSize: 8,
      fontWeight: pw.FontWeight.normal,
      fontBoldItalic: pw.Font.times(),
    );
  }

  pw.Widget titlePages(
    Uint8List imagenBytes,
    Uint8List imgRunnner,
  ) {
    const colorRed = PdfColor.fromInt(0xFFA01313); // Marrón
    const colorBlack = PdfColor.fromInt(0xFF000000);
    return pw.Container(
      alignment: pw.Alignment.center,
      color: colorRed,
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Image(
                pw.MemoryImage(imgRunnner),
                height: 30,
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'CORREDORES',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      fontBoldItalic: pw.Font.times(),
                      color: colorBlack,
                    ),
                  ),
                  pw.Text(
                    'Registros: ${widget.listaCorrdores.length}',
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: colorBlack,
                      fontBoldItalic: pw.Font.times(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.Container(
            width: 130,
            child: pw.Column(
              children: [
                pw.Image(
                  pw.MemoryImage(imagenBytes),
                  width: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget fooTerPDF() {
    const colorRed = PdfColor.fromInt(0xFF7D0F0F); // Marrón // Marrón
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'The chaski Challenge.'.toUpperCase(),
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              fontBoldItalic: pw.Font.times(),
              color: colorRed), // Color gris oscuro personalizado
        ),
        pw.Text(
          DateTime.now().toString(),
          style: pw.TextStyle(
              fontSize: 8, fontBoldItalic: pw.Font.times(), color: colorRed),
        ),
      ],
    );
  }
}
