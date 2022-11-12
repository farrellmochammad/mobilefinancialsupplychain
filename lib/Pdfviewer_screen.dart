import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';


class PdfViewer extends StatefulWidget {
  @override
  _PdfViewer createState() => _PdfViewer();
}

class _PdfViewer extends State<PdfViewer> {

  @override
  void initState() {
    super.initState();
  }

  Future<PDFDocument> loadDocument() async {
    PDFDocument document = await _fetchPdf();
    debugPrint("Document length : " + document.count.toString());
    return document;
  }

  Future<PDFDocument> _fetchPdf() async {
    var doc = await PDFDocument.fromURL(
      "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf",
    );
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterPluginPDFViewer'),
      ),
      body: Center(
        child: FutureBuilder<PDFDocument>(
          future: loadDocument(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Center(
              child: PDFViewer(
                document: snapshot.data,
                zoomSteps: 1,
              ),
            );
            // if (snapshot.hasData) {
            //   return Center(
            //     child: PDFViewer(
            //       document: snapshot.data,
            //       zoomSteps: 1,
            //     ),
            //   );
            // } else {
            //   debugPrint("Has no data");
            //   return Center(child: Text("Tidak bisa melihat file .pdf"));
            // }
          },
        ),
      ),
    );
  }
}

// class PdfViewer extends StatelessWidget {
//
//   // In the constructor, require a Todo.
//   const PdfViewer({super.key, required this.fileUrl});
//
//   // Declare a field that holds the Todo.
//   final String fileUrl;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter PDF Viewer'),
//       ),
//       body: SfPdfViewer.network(
//           'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
//           scrollDirection: PdfScrollDirection.horizontal
//       ),
//     );
//   }
// }


