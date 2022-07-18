import 'package:sqflite/sqflite.dart';

class DatabaseQueryException extends DatabaseException {
  DatabaseQueryException(super.message);

  @override
  int? getResultCode() {
    throw UnimplementedError();
  }

  @override
  Object? get result => throw UnimplementedError();

}