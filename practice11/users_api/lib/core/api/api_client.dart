import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  final http.Client _client;
  final String host;

  Map<String, String> get headers => {'Accept': 'application/json'};

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response response) {
    if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }

    if (response.statusCode == 404) {
      throw const NotFoundException();
    }

    if (response.statusCode >= 500) {
      throw ServerException(response.statusCode);
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException catch (e) {
      throw BadResponseException(e.message);
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      log('${response.statusCode} ${response.request?.url}', name: 'api');
    }
  }

  Future<dynamic> get(Uri uri) async {
    final response = await _send(() => _client.get(uri, headers: headers));

    _logResponse(response);
    _check(response);

    return _decode(response);
  }

  Future<dynamic> post(
    Uri uri, {
    required String body,
    Map<String, String> additionalHeaders = const {},
  }) async {
    final response = await _send(
      () => _client.post(
        uri,
        headers: {...headers, ...additionalHeaders},
        body: body,
      ),
    );

    _logResponse(response);
    _check(response);

    if (response.statusCode != 201) {
      throw BadResponseException(
        'Expected status 201, got ${response.statusCode}',
      );
    }

    return _decode(response);
  }
}
