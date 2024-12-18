import 'package:exam_ai/api/exam_service.dart';
import 'package:exam_ai/components/details.dart';
import 'package:exam_ai/constants/const.dart';
import 'package:exam_ai/page/third_page/thirdDesktop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SecondDesktop extends StatefulWidget {
  const SecondDesktop({super.key});

  @override
  State<SecondDesktop> createState() => _SecondDesktopState();
}

class _SecondDesktopState extends State<SecondDesktop> {
  bool _highlightUploadButton = false;
  bool isFileSelected = true;
  final ExamService _examService = ExamService();
  TextEditingController items = TextEditingController();
  TextEditingController examFormatController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  PlatformFile? file;
  int selectedSubject = 0;
  int selectedExamFormat = 0;
  int selectedExamType = 0;
  int selectedItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.amber),
              child: const Text("Creator's page"),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(147, 216, 90, 1),
        toolbarHeight: 30,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(style: BorderStyle.solid)),
            padding: const EdgeInsets.all(10),
            child: topRow(context),
          ),

          const SizedBox(
            height: 20,
          ),
          //2
          Details(
            label: 'Subject',
            entries: subjects,
            selectedValue: selectedSubject,
            controller: subjectController,
            onSelected: (value) {
              setState(() {
                selectedSubject = value ?? 0;
              });
            },
          ),

          const SizedBox(
            height: 30,
          ),
          Details(
            label: 'Exam Formats',
            entries: examFormats,
            selectedValue: selectedExamFormat,
            controller: examFormatController,
            onSelected: (value) {
              setState(() {
                selectedExamFormat = value ?? 0;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          examMethod(),
          const SizedBox(
            height: 30,
          ),
          itemDropdown(),
        ],
      ),
    );
  }

  DropdownMenu<int> itemDropdown() {
    return DropdownMenu(
      label: const Text('Items'),
      dropdownMenuEntries: numba[selectedExamType] ?? [],
      menuHeight: 234,
      width: 250,
      onSelected: (int? value) {
        if (value != null)
          setState(() {
            selectedItemCount = value ?? 0;
          });
      },
    );
  }

  DropdownMenu<dynamic> examMethod() {
    return DropdownMenu(
      label: const Text('Exam Type'),
      dropdownMenuEntries: examType,
      controller: items,
      menuHeight: 234,
      width: 250,
      onSelected: (value) {
        setState(() {
          selectedExamType = value ?? 0;
          selectedItemCount = 0;
        });
      },
    );
  }

  Row topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 30),
        Row(
          children: [
            IconButton(
              onPressed: pickFile,
              icon: const Icon(Icons.cloud_upload_outlined),
              color: _highlightUploadButton ? Colors.red : Colors.blueAccent,
            ),
            const SizedBox(width: 10),
            if (file == null && !isFileSelected)
              const Text(
                'No file selected',
                style: TextStyle(
                  color: Colors.red, // Red color to show error
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Smaller font for validation message
                ),
              ),
            if (file != null) showSelectedFile(),
          ],
        ),
        const Expanded(
            child: const SizedBox(
          width: 500,
        )),
        createMockExamButton(context),
      ],
    );
  }

  FilledButton createMockExamButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () async {
        if (file == null) {
          setState(() {
            _highlightUploadButton = true;
            isFileSelected = false;
          });
          Future.delayed(const Duration(microseconds: 500), () {
            setState(() {
              _highlightUploadButton = false;
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'File not yet selected: Before creating a mock exam please select a file first')),
          );
          return;
        }
        final result = await _examService.generateMockQuestions(
            file!,
            selectedSubject,
            selectedExamFormat,
            selectedExamType,
            selectedItemCount);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ThirdDesktop(result: result, fileName: file!.name),
            ),
          );
        }
      },
      label: const Text('CREATE'),
      icon: const Icon(Icons.add),
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.purple[900])),
    );
  }

  //display selected file
  Row showSelectedFile() {
    return Row(
      children: [
        const Text('Selected File: '),
        InputChip(
          label: Text(file!.name),
          onDeleted: () {
            setState(() {
              file = null;
              isFileSelected = true;
            });
          },
        ),
      ],
    );
  }

  //for picking file
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xml', 'docx', 'txt'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        file = result.files.single;
        isFileSelected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File "${file!.name}" selected.')),
      );
    }
  }
}
