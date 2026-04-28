import 'dart:developer' as dev;

import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbConnection {

  DbConnection._internal();
  static final DbConnection _instance = DbConnection._internal();

  static DbConnection get instance => _instance;

  Db? _db;

  bool get isConnected => _db?.isConnected ?? false;


  Db get db {
    if (_db == null || !isConnected) {
      throw DbConnectionException(
        'Database not connected. Call DbConnection.instance.connect() first.',
      );
    }
    return _db!;
  }

  Future<void> connect() async {
    if (isConnected) {
      dev.log('Already connected — skipping.', name: 'DbConnection');
      return;
    }

    // 1. Read the URI from the environment variables
    final uri = dotenv.env['MONGODB_URI'];
    if (uri == null || uri.isEmpty) {
      throw DbConnectionException(
        'MONGODB_URI is not defined in the .env file.',
      );
    }

    try {
      dev.log(' DbConnection: Connecting to MongoDB…', name: 'DbConnection');

      _db = await Db.create(uri);
      await _db!.open();

      dev.log(
        'Connected — database: ${_db!.databaseName}',
        name: 'DbConnection',
      );
    } catch (e, st) {
      _db = null;
      dev.log(
        ' DbConnection: Failed to connect.',
        name: 'DbConnection',
        error: e,
        stackTrace: st,
      );
      throw DbConnectionException('Could not connect to MongoDB: $e', cause: e);
    }
  }

  Future<void> disconnect() async {
    if (!isConnected) return;

    try {
      await _db?.close();
      dev.log(' Disconnected.', name: 'DbConnection');
    } catch (e, st) {
      dev.log(
        'Error while disconnecting.',
        name: 'DbConnection',
        error: e,
        stackTrace: st,
      );
    } finally {
      _db = null;
    }
  }
}

class DbConnectionException implements Exception {
  final String message;
  final Object? cause;

  const DbConnectionException(this.message, {this.cause});

  @override
  String toString() =>
      'DbConnectionException: $message'
      '${cause != null ? '\nCaused by: $cause' : ''}';
}
