
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfViewController extends GetxController {
  String pdfContent = "";
  String fileName = "document";

  // String pdfByte = "";
  String generatedPdfFilePath = '';
  String urlPath = '';
  bool isShow = false;

  @override
  void onInit() async {
    super.onInit();
    await requestStoragePermission();
    if (Get.arguments != null) {
      pdfContent = Get.arguments["html"];
      fileName = Get.arguments["fileName"] ?? "document";
      isShow = false;
      // if (pdfContent.startsWith("http")) {
      //   isShow = true;
      //   downloadFile(pdfContent.split("/").last, pdfContent);
      // } else {
      if (pdfContent.startsWith("http")) {
        await downloadFile("$fileName${DateTime.now().millisecondsSinceEpoch}.pdf", pdfContent);
      } else {
        pdfContent = pdfContent;
        await generatePdfFromHtml();
      }
      // await generatePdfFromHtml();
      // }
    }
  }

  Future<void> requestStoragePermission() async {
    if (!Platform.isAndroid) return;

    if (await Permission.storage.isGranted) return;

    final status = await Permission.storage.request();

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> downloadFile(String fileName, String documentUrl) async {
    try {
      isShow = false;
      urlPath = '';
      generatedPdfFilePath = '';
      update();

      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) throw Exception("Could not find directory");

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      // final directory = await getExternalStorageDirectory();
      // final dirPath = directory?.path ?? "/storage/emulated/0/Download";
      // final filePath = '$dirPath/$fileName';

      if (await File(filePath).exists()) {
        await File(filePath).delete();

        // urlPath = filePath;
        // isShow = true;
        // update();
        // return;
      }

      final request = await HttpClient().getUrl(Uri.parse(documentUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        final file = File(filePath);
        await response.pipe(file.openWrite());
        urlPath = file.path;
        generatedPdfFilePath = file.path;
        isShow = true;
        update();
      } else {
      }
    } catch (err) {
      print("Download Error: $err");
    }
  }


  Future<void> generatePdfFromHtml() async {

    try {

      /// Download folder
      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      // Directory directory = Directory("/storage/emulated/0/Download");
      //
      // if(!await directory.exists()){
      //   directory.create(recursive: true);
      // }

      final targetPath = directory!.path;

      final targetFileName = '$fileName${DateTime.now().millisecondsSinceEpoch}';

      final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
        htmlContent: pdfContent,
        printPdfConfiguration: PrintPdfConfiguration(
          targetDirectory: targetPath,
          targetName: targetFileName,
          printSize: PrintSize.A4,
          printOrientation: PrintOrientation.Portrait,
        ),
      );

      generatedPdfFilePath = generatedPdfFile.path;

      print("PDF Saved At: $generatedPdfFilePath");

      isShow = true;

      update();

      Get.snackbar(
        "Success",
        "PDF Downloaded in Download Folder",
      );

    } catch (e) {

      print("PDF Error: $e");

      Get.snackbar(
        "Error",
        "PDF generation failed",
      );

    }

  }


  String generateFileName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'output_$timestamp';
  }


}
