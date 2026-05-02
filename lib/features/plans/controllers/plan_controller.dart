import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:gym_management_app/core/network/db_connection.dart';
import '../models/plan_model.dart';
import 'dart:developer' as dev;

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

  // 🔹 GET ALL Plans
  Future<void> getPlans() async {
    try {
      await DbConnection.instance.ensureConnected(); // ✅
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final data = await _collection.find().toList();

      plans = data.map((e) => PlanModel.fromMap(e)).toList();

    } catch (e) {
      errorMessage = e.toString();
      dev.log("Error in getPlans: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPlan({
    required String planName,
    required int durationDays,
    required int price,
  }) async {
    final plan = PlanModel(
      planName: planName,
      durationDays: durationDays,
      price: price,
    );

    try {
      final doc = plan.toMap();
      await _collection.insert(doc);

      final insertedPlan = PlanModel.fromMap(doc);
      plans.add(insertedPlan);
      notifyListeners();

    } catch (e, stack) {
      print("❌ Insert error: $e");
      print(stack);
      rethrow; // so the UI SnackBar shows
    }
  }

  Future<PlanModel?> getPlanById(String id) async {
    try {
      await DbConnection.instance.ensureConnected();

      final objId = ObjectId.fromHexString(id);

      final doc = await _collection.findOne({"_id": objId});

      if (doc == null) return null;

      return PlanModel.fromMap(doc);

    } catch (e) {
      dev.log("Error in getPlanById: $e");
      return null;
    }
  }

}