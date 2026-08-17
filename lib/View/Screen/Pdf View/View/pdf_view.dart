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
          floatingActionButton: controller.isShow
              ? FloatingActionButton(
                  onPressed: () {
                    final path = controller.shareFilePath;
                    if (path.isNotEmpty) {
                      Share.shareXFiles([XFile(path)]);
                    }
                  },
                  child: const Icon(Icons.share),
                )
              : null,
          appBar: AppBar(
            title: const Text('Pdf View'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBody(controller),
          ),
        );
      },
    );
  }

  Widget _buildBody(PdfViewController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!controller.isShow) {
      return const Center(child: Text('Unable to load PDF'));
    }

    if (controller.generatedPdfFilePath.isNotEmpty) {
      return SfPdfViewer.file(
        File(controller.generatedPdfFilePath),
        key: ValueKey(controller.generatedPdfFilePath),
        pageLayoutMode: PdfPageLayoutMode.continuous,
        interactionMode: PdfInteractionMode.pan,
      );
    }

    if (controller.pdfContent.startsWith("http")) {
      return SfPdfViewer.network(
        controller.pdfContent,
        key: ValueKey(controller.pdfContent),
        pageLayoutMode: PdfPageLayoutMode.continuous,
        interactionMode: PdfInteractionMode.pan,
      );
    }

    return const Center(child: Text('Unable to load PDF'));
  }
}
