// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_application/pagees/details_page.dart';
import 'package:cloud_firestore_application/service/cloud_firestore_service.dart';
import 'package:cloud_firestore_application/widgets/colorful.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool descending = false;

  Color txtColor = const Color(0xFF646464);

  Widget _buildCard(
      {required Color color, required Map<String, dynamic> data}) {
    return Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                data["title"],
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: txtColor),
              ),
            ),
            Center(
              child: Text(
                data["content"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: txtColor,
                ),
              ),
            ),
          ],
        ));
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteNoteAndRefresh(id);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteNoteAndRefresh(String id) async {
    await CFSService.delete(id: id);
    // CFSService.documents.removeWhere((element) => element.id == id);
    print("Successfully deleted");
    loadNotes();
    // setState(() {});
  }

  void _openDataWithNote(String id, Map<String, dynamic> json) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => DetailsPage(
                  title: json["title"],
                  content: json["content"],
                  id: id,
                )));
    loadNotes();
    // setState(() {});
  }

  void loadNotes() async {
    await CFSService.readAllData(descending: descending);
    print("loaded notes");
    setState(() {});
  }

  @override
  void initState() {
    loadNotes();
    print("initialized");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CFSService.db.collection(CFSService.path).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Center(
              child: Text(
                "Recent Notes",
                style: TextStyle(color: Colors.black),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    descending = !descending;
                    print("descending = $descending");
                    loadNotes();
                  });
                },
                icon: const Icon(CupertinoIcons.arrow_up_arrow_down),
              )
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: MasonryGridView.builder(
                itemCount: CFSService.documents.length,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  var item = CFSService.documents[index];
                  return InkWell(
                    onLongPress: () {
                      _showDeleteConfirmationDialog(item.id);
                    },
                    onTap: () {
                      _openDataWithNote(item.id, item.data());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildCard(
                          color: Colorful.colors[index], data: item.data()),
                    ),
                  );
                },
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => DetailsPage()),
              );
              setState(() {});
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}
