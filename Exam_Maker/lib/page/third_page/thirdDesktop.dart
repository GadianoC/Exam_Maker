import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';

class ThirdDesktop extends StatelessWidget {
  const ThirdDesktop({super.key, required this.result, required this.fileName});

  final String result;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: const Text(
          'Exam Result',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: Colors.purple[900], 
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await _downloadPDFWeb(result, fileName, context);
              },
              child: const Text(
                'Download PDF',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 600, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'File Name: $fileName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 14),
                  const Text(
                    'Exam Result:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    _removeFormatting(result),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadPDFWeb(
      String content, String fileName, BuildContext context) async {
    final pdf = pw.Document();

    try {
      final lines = content.split('\n');
      int startIndex = 0;
      const maxLinesPerPage = 32;

      while (startIndex < lines.length) {
        final chunk = StringBuffer();
        int lineCount = 0;

        while (startIndex < lines.length && lineCount < maxLinesPerPage) {
          chunk.writeln(lines[startIndex]);
          lineCount++;
          startIndex++;
        }

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _parseContent(chunk.toString()),
                ],
              );
            },
          ),
        );
      }

      final pdfBytes = await pdf.save();
      final buffer = pdfBytes.buffer.asUint8List();
      final blob = html.Blob([buffer]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = '${fileName.replaceAll(' ', '_')}_exam_result.pdf'
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error during PDF generation: $e');
    }
  }

  String _removeFormatting(String content) {
    return content.replaceAll(RegExp(r'\*\*|\*|##|_'), '').trim();
  }

  pw.Widget _parseContent(String content) {
    final lines = content.split('\n');
    final List<pw.Widget> widgets = [];

    for (var line in lines) {
      line = line.replaceAll(RegExp(r'\*\*|\*|##|_'), '');
      widgets.add(pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(line, style: pw.TextStyle(fontSize: 12)),
      ));
      widgets.add(pw.SizedBox(height: 5));
    }

    return pw.Column(children: widgets);
  }
}
