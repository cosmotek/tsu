import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import './sqlcontext.dart';
import './sqltable.dart';

Widget SQLTableStructure({@required SQLConfig config, @required String tableName}) {
  PostgreSQLConnection db = config.toPostgresConnection();
  final String tableQueryStr =
"""
select
  column_name,
  ordinal_position,
  column_default,
  is_nullable,
  data_type,
  character_maximum_length
from information_schema.columns where table_name = '$tableName';
""";

  return SQLTable(config: config, queryStr: tableQueryStr);
}