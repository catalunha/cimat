import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:cimat/app/core/models/caution_model.dart';

class CautionPrintPage extends StatelessWidget {
  List<CautionModel> cautionList;
  CautionPrintPage({
    Key? key,
    required this.cautionList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: 'relatorio',
        build: (format) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    // await getImages();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginTop: 1.0 * PdfPageFormat.cm,
          marginLeft: 1.0 * PdfPageFormat.cm,
          marginRight: 1.0 * PdfPageFormat.cm,
          marginBottom: 1.0 * PdfPageFormat.cm,
        ),
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        footer: (pw.Context context) => footerPage(context),
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
            level: 1,
            child: pw.Text('Relatório de cautelas'),
          ),
          ...body(),
        ],
      ),
    );

    return await pdf.save();
  }

  body() {
    List<pw.Widget> lineList = [];
    for (var caution in cautionList) {
      lineList.add(userBody(caution));
    }

    return lineList;
  }

  // getImages() async {
  //   for (var caution in _cautionSearchController.cautionList) {
  //     if (caution.photo != null) {
  //       final image = await networkImage(caution.photo!);
  //       //     final image =
  //       // await flutterImageProvider(NetworkImage(caution.photo ?? ''));
  //       images[caution.id!] = image;
  //     } else {
  //       images[caution.id!] = null;
  //     }
  //   }
  // }

  userBody(CautionModel caution) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(children: [
          // if (images[caution.id] != null)
          //   pw.Center(
          //     child: pw.Image(height: 200, width: 200, images[caution.id]!),
          //   ),
          pw.SizedBox(width: 10),
          pw.Expanded(
              child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Entregador. Nome: ${caution.deliveryUserProfile?.name}'),
              pw.Text(
                  'Entregador. Entregou item em: ${caution.deliveryDt == null ? "..." : dateFormat.format(caution.deliveryDt!)}'),
              pw.Text('Item: ${caution.item?.description}'),
              pw.Text('Operador. Nome: ${caution.receiverUserProfile?.name}'),
              pw.Text(
                'Operador. Análise do item ? ${caution.receiverItemWasAccepted == null ? 'em andamento.' : caution.receiverItemWasAccepted == true ? 'Conferido e aceito.' : 'Conferido e recusado.'}',
              ),
              pw.Text(
                  'Operador. Analisado em: ${caution.receiverAnalyzedItemDt == null ? "..." : dateFormat.format(caution.receiverAnalyzedItemDt!)}'),
              pw.Text(
                  'Operador. Considera item permanente ? ${caution.receiverIsPermanentItem == true ? 'Sim' : 'Não'}'),
              pw.Text(
                  'Operador. Iniciou devolução ? ${caution.receiverIsStartGiveback == null ? 'Não. Ainda analisando item.' : caution.receiverIsStartGiveback == true ? 'Sim.' : 'Não.'}'),
              pw.Text(
                  'Operador. Devolução iniciada em: ${caution.receiverGivebackItemDt == null ? "..." : dateFormat.format(caution.receiverGivebackItemDt!)}'),
              pw.Text(
                  'Operador. Descrição de devolução: ${caution.receiverGivebackDescription}'),
              pw.Text('Recebedor. Nome: ${caution.givebackUserProfile?.name}'),
              pw.Text(
                'Recebedor. Análise do item ? ${caution.givebackItemWasAccepted == null ? 'em andamento.' : caution.givebackItemWasAccepted == true ? 'Conferido e aceito.' : 'Conferido e atualizar documentação.'}',
              ),
              pw.Text(
                  'Recebedor. Analisado em: ${caution.receiverAnalyzedItemDt == null ? "..." : dateFormat.format(caution.givebackAnalyzedItemDt!)}'),
              pw.Text(
                  'Recebedor. Descrição de recebimento: ${caution.givebackDescription}'),
            ],
          ))
        ]),
        pw.Divider(),
      ],
    );
  }

  footerPage(context) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      decoration: const pw.BoxDecoration(
          border: pw.Border(
              top: pw.BorderSide(width: 1.0, color: PdfColors.black))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'cimat - ${dateFormat.format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Pág.: ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
