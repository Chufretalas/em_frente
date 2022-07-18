import 'package:sqflite/sqflite.dart';

class DatabaseQueryException extends DatabaseException {
  DatabaseQueryException(super.message);

  @override
  int? getResultCode() {
    // TODO: implement getResultCode
    throw UnimplementedError();
  }

  @override
  // TODO: implement result
  Object? get result => throw UnimplementedError();

}