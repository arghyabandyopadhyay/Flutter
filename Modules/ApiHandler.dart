import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:ArghyaBandyopadhyay/Models/JsonModel.dart';
import 'package:ArghyaBandyopadhyay/Models/RequestJSON/ApiHeaderModel.dart';
import 'package:ArghyaBandyopadhyay/Models/RequestJSON/Parameter.dart';
import 'package:ArghyaBandyopadhyay/Models/RequestJSON/UniversalJson.dart';
import 'package:ArghyaBandyopadhyay/Models/TokenModel.dart';

Future<TokenModel> getToken(String userName, String password) async {
  Map data = {
    "grant_type": "password",
    "Username": userName,
    "Password": password,
  };
  http.Response response;
  try {
    response = await http
        .post(
          '${apiUrl}token',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: data,
        )
        .timeout(Duration(seconds: 5));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value == ConnectivityResult.none)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    if (response.body == "Unable to Connect to remote Server") {
      throw 500;
    } else {
      if (response.body.isNotEmpty)
        return TokenModel.fromJson(json.decode(response.body));
      else
        throw "NoData";
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    print(response.statusCode);
    throw "ErrorHasOccurred";
  }
}

Future<List<JsonModel>> universalFetch(
    String requestType, String uID, List<Parameter> pList) async {
  RequestJson requestJson =
      new RequestJson(requestType: requestType, parameterList: pList);
  UniversalJson universalJson =
      new UniversalJson(UID: uID, requestJSON: requestJson);
  String body = json.encode(universalJson);
  String responseBody = await responseGeneratorPost(body, 15);
  return ((json.decode(responseBody)) as List)
      .map((data) => JsonModel.fromJson(data))
      .toList();
}

Future<List> universalFetchDynamic(
    String requestType, String uID, List<Parameter> pList) async {
  RequestJson requestJson =
      new RequestJson(requestType: requestType, parameterList: pList);
  UniversalJson universalJson =
      new UniversalJson(UID: uID, requestJSON: requestJson);
  String body = json.encode(universalJson);
  String responseBody = await responseGeneratorPost(body, 15);
  return (json.decode(responseBody)) as List;
}

Future<String> responseGeneratorPost(String body, int timeOut) async {
  //The token generation must be done in a different place.
  //Else each api call will generate a new token which should not happen and would increase the latency.
  //I have done it here just to show how the token can be generated.
  TokenModel token = await getToken(userName, password);
  http.Response response;
  ApiHeaderModel headerModel = new ApiHeaderModel(
      authorization: token.tokenType + " " + token.accessToken,
      contentType: 'application/json; charset=UTF-8');
  try {
    response = await http
        .post(
          dataExchangeURL,
          headers: headerModel.toJson(),
          body: body,
        )
        .timeout(Duration(seconds: timeOut));
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value == ConnectivityResult.none)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
  if (response.statusCode == 201 || response.statusCode == 200) {
    if (response.body == "Unable to Connect to remote Server") {
      throw 500;
    } else {
      if (response.body.isNotEmpty) {
        return response.body;
      } else
        throw "NoData";
    }
  } else if (response.statusCode == 500) {
    throw 500;
  } else {
    print(response.statusCode);
    throw "ErrorHasOccurred";
  }
}
