import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfViewController extends GetxController {
  String pdfContent = "";
  String fileName = "document";
  String generatedPdfFilePath = '';
  String urlPath = '';
  bool isShow = false;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    _initPdf();
  }

  Future<void> _initPdf() async {
    await requestStoragePermission();

    final args = Get.arguments;
    if (args == null) {
      isLoading = false;
      update();
      return;
    }

    pdfContent = (args["html"] as String?)?.trim() ?? "";
    fileName = args["fileName"] ?? "document";
    isShow = false;
    isLoading = true;
    update();

    if (pdfContent.isEmpty) {
      _showError("No content received from server");
      return;
    }

    if (_isRemoteUrl(pdfContent)) {
      await downloadFile("$fileName${DateTime.now().millisecondsSinceEpoch}.pdf", pdfContent);
    } else {
      await generatePdfFromHtml();
    }
  }

  bool _isRemoteUrl(String value) {
    final trimmed = value.trim().toLowerCase();
    return trimmed.startsWith("http://") || trimmed.startsWith("https://");
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

      final directory = await _getSaveDirectory();
      if (directory == null) throw Exception("Could not find directory");

      final filePath = '${directory.path}/$fileName';

      if (await File(filePath).exists()) {
        await File(filePath).delete();
      }

      final request = await HttpClient().getUrl(Uri.parse(documentUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        final file = File(filePath);
        await response.pipe(file.openWrite());
        urlPath = file.path;
        generatedPdfFilePath = file.path;
        isShow = true;
      } else {
        _showError("Failed to download PDF");
      }
    } catch (err) {
      debugPrint("Download Error: $err");
      _showError("PDF download failed");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> generatePdfFromHtml() async {
    try {
      final directory = await _getSaveDirectory();
      if (directory == null) throw Exception("Could not find directory");

      final targetPath = directory.path;
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
      urlPath = generatedPdfFile.path;
      isShow = true;

      Get.snackbar(
        "Success",
        "PDF Downloaded in Download Folder",
      );
    } catch (e) {
      debugPrint("PDF Error: $e");
      _showError("PDF generation failed");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<Directory?> _getSaveDirectory() async {
    if (Platform.isAndroid) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) return downloadDir;
      return getExternalStorageDirectory();
    }
    return getApplicationDocumentsDirectory();
  }

  void _showError(String message) {
    isShow = false;
    isLoading = false;
    update();
    Get.snackbar("Error", message);
  }

  String get shareFilePath {
    if (generatedPdfFilePath.isNotEmpty) return generatedPdfFilePath;
    return urlPath;
  }
}
