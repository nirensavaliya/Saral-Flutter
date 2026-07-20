import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../Controller/pdf_controller.dart';

class PdfView extends GetView<PdfViewController> {
  const PdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfViewController>(
      builder: (controller) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.share),
            onPressed: () {
              print("controller.filePathPdf --- ${controller.urlPath}");
              if(controller.pdfContent.startsWith("http"))
              {
                Share.shareXFiles([XFile(controller.urlPath)]);
              }
              else
              {
                Share.shareXFiles([XFile(controller.generatedPdfFilePath)]);
              }
            },
          ),
          appBar: AppBar(
            title: const Text('PdfViewView'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: controller.isShow
                ? controller.pdfContent.startsWith("http")
                ? SfPdfViewer.network(
              controller.pdfContent,
              key: ValueKey(controller.pdfContent),
              pageLayoutMode: PdfPageLayoutMode.continuous,
              interactionMode: PdfInteractionMode.pan,
            )
                : SfPdfViewer.file(
              key: ValueKey(controller.urlPath),
              File(
                controller.generatedPdfFilePath,
              ),
              pageLayoutMode: PdfPageLayoutMode.continuous,
            )
                : Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
