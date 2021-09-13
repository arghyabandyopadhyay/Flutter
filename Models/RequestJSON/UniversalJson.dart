import 'dart:convert';

import 'Parameter.dart';

class UniversalJson
{
  String uID;
  RequestJson requestJSON;
  UniversalJson({this.uID,this.requestJSON});

  Map toJson() =>
      {
        "UID":uID,
        "RequestDateTime":DateTime.now().toIso8601String(),
        "RequestJSON":json.encode(requestJSON)
      };
}
class RequestJson
{
  String requestType;
  List<Parameter> parameterList;
  RequestJson({this.requestType,this.parameterList});

  Map toJson() =>
      {
        "RequestType":requestType,
        "ParameterList":parameterList,
      };
}