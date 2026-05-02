import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:gym_management_app/core/network/db_connection.dart';
import '../models/trainer_model.dart';

class TrainerController extends ChangeNotifier {
  final String _collectionName = "trainers";

  bool isLoading = false;
  String? errorMessage;
  List<TrainerModel> trainers = [];

  DbCollection get _collection => DbConnection.instance.db.collection(_collectionName);

  // 🔹 GET ALL TRAINERS
  Future<void> getTrainers() async {
    try {
      await DbConnection.instance.ensureConnected(); // ✅
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final data = await _collection.find().toList();
      print("Trainers from DB: $data"); // check console

      trainers = data.map((e) => TrainerModel.fromJson(e)).toList();
      print("Parsed trainers: ${trainers.length}"); // check console

    } catch (e) {
      errorMessage = e.toString();
      dev.log("Error in getTrainers: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 GET ALL TRAINERS DROPDOWN
  Future<void> getTrainersForDropdown() async {
    try {
      await DbConnection.instance.ensureConnected(); // ✅
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final data = await _collection.find().toList(); // ✅ removed where.fields()

      trainers = data.map((e) => TrainerModel.fromJson(e)).toList();

    } catch (e) {
      errorMessage = e.toString();
      dev.log("Error in getTrainersForDropdown: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 ADD TRAINER
  Future<void> addTrainer({
    required String fullName,
    required String phoneNumber,
    required String bio,
    required Map<String, dynamic> schedule,
  }) async {
    final trainer = TrainerModel(
      fullName: fullName,
      phoneNumber: phoneNumber,
      bio: bio,
      schedule: schedule,
      createdAt: DateTime.now(),
    );

    try {
      final doc = trainer.toJson();
      await _collection.insert(doc);

      final insertedTrainer = TrainerModel.fromJson(doc);
      trainers.add(insertedTrainer);
      notifyListeners();

    } catch (e, stack) {
      print("❌ Insert error: $e");
      print(stack);
      rethrow; 
    }
  }

  Future<TrainerModel?> getTrainerById(String id) async {
    try {
      await DbConnection.instance.ensureConnected();

      final objId = ObjectId.fromHexString(id);

      final doc = await _collection.findOne({"_id": objId});

      if (doc == null) return null;

      return TrainerModel.fromJson(doc);

    } catch (e) {
      debugPrint("Error in getTrainerById: $e");
      return null;
    }
  }
}