import 'package:cloud_firestore_application/service/cloud_firestore_service.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  String? id;
  String? title;
  String? content;
  DetailsPage({super.key, this.title, this.content, this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isNew = false;

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  void store() async {
    Map<String, dynamic> json = {
      "title": title.text,
      "content": content.text,
    };
    if (isNew) {
      await CFSService.storeData(data: json);
      print("succesfully stored");
    } else {
      await CFSService.update(id: widget.id!, data: json);
      print("successfully updated");
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.title == null) {
      title.text = "";
      content.text = "";
      isNew = true;
    } else {
      title.text = widget.title ?? "";
      content.text = widget.content ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3BF),
      appBar: AppBar(
          backgroundColor: const Color(0xFFFDF3BF),
          title: const Center(
            child: Text("Edit Note"),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.done_rounded,
                size: 27,
              ),
              onPressed: () {
                store();
                print("saved");
              },
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.more_vert,
              size: 27,
            ),
            const SizedBox(
              width: 10,
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ListView(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                style: const TextStyle(
                  fontSize: 24, // Set the font size
                  fontWeight: FontWeight.bold, // Set the font weight
                ),
                controller: title,
                maxLength: 15,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent), // No border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.transparent), // No border when not focused
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: TextField(
                controller: content,
                maxLength: 500,
                maxLines: 25,
                decoration: const InputDecoration(
                  hintText: "Content",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent), // No border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.transparent), // No border when not focused
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
