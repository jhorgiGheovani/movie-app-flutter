import 'dart:io';

import 'package:ditonton/common/ssl_pinning_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ssl pingin success', () async {
    const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
    const BASE_URL = 'https://api.themoviedb.org/3';
    final _client = await Shared.createLEClient(isTestMode: true);
    final response =
        await _client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));
    expect(response.statusCode, 200);
    _client.close();
  });

  test('ssl pingin wrong', () async {
    final _client = await Shared.createLEClient(isTestMode: true);
    try {
      await _client.get(Uri.parse('https://www.google.com/'));
      // If no exception is thrown, fail the test
      fail('Expected HandshakeException but no exception was thrown.');
    } catch (error) {
      // Check if the caught error is a HandshakeException
      expect(error is HandshakeException, isTrue);
    }

    _client.close();
  });
}
