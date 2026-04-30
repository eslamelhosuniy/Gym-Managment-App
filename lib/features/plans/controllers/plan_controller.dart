import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:gym_management_app/core/network/db_connection.dart';
import '../models/plan_model.dart';

class PlanController extends ChangeNotifier {
  Db get _db => DbConnection.instance.db;

  final String _collectionName = "plans";

  bool isLoading = false;
  String? errorMessage;

  List<PlanModel> plans = [];

  // Pagination
  int _currentPage = 0;
  final int _limit = 10;
  bool hasMore = true;

  DbCollection get _collection => _db.collection(_collectionName);

  // 🔹 GET ALL PLANS DROPDOWN
  Future<void> getPlansForDropdown() async {
    try {
        await DbConnection.instance.ensureConnected(); // ✅
        isLoading = true;
        errorMessage = null;
        notifyListeners();

        final data = await _collection.find().toList(); // ✅
        print("Plans from DB: $data"); // check console

        plans = data.map((e) => PlanModel.fromMap(e)).toList();
        print("Parsed plans: ${plans.length}"); // check console

    } catch (e) {
            errorMessage = e.toString();
            debugPrint("Error in getPlansForDropdown: $e");
    } finally {
            isLoading = false;
            notifyListeners();
    }
  }

}