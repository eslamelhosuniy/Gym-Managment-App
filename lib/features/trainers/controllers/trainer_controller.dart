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
  Future<void> addTrainer(TrainerModel trainer) async {
    try {
      await DbConnection.instance.ensureConnected(); // ✅
      await _collection.insert(trainer.toJson());
      trainers.add(trainer);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      dev.log("Error in addTrainer: $e");
    }
  }
}