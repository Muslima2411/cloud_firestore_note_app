import 'package:cloud_firestore/cloud_firestore.dart';

class CFSService {
  static const path = "notik";

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];

  static Future<void> storeData({required Map<String, dynamic> data}) async {
    await db.collection(path).add(data);
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> readAllData(
      {bool? descending}) async {
    documents.clear();
    await db
        .collection(path)
        .orderBy("title", descending: descending ?? false)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        documents.add(doc);
      }
    });
    return documents;
  }

  static Future<void> delete({required String id}) async {
    await db.collection(path).doc(id).delete();
  }

  static Future<void> update(
      {required String id, required Map<String, dynamic> data}) async {
    await db.collection(path).doc(id).update(data);
  }
}
