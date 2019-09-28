import 'package:postgres/postgres.dart';

class SQLContext {
  String name;
  String queryString;

  List<Map<String, Map<String, dynamic>>> result;
  String errorMsg;

  SQLContext({this.name, this.queryString, this.result});
}

class SQLConfig {
  String host;
  int port;
  String username;
  String password;
  String database;

  SQLConfig({this.host, this.port, this.username, this.password, this.database});

  PostgreSQLConnection toPostgresConnection() {
    return new PostgreSQLConnection(
      host,
      port,
      database,
      username: username,
      password: password,
    );
  }
}