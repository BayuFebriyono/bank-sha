import 'dart:convert';

import 'package:http/http.dart' as http;

import '../shared/shared_values.dart';
import 'auth_service.dart';

class WalletService {
  Future<void> updatePin(String oldPin, String newPin) async {
    try {
      final token = await AuthService().getToken();

      final res = await http.put(
          Uri.parse(
            '$baseUrl/wallets',
          ),
          body: {
            'previous_pin' : oldPin,
            'new_pin' : newPin,
          },
          headers: {
            'Authorization': token,
          });

          if(res.statusCode != 200){
            throw jsonDecode(res.body)['message'];
          }
    } catch (e) {
      rethrow;
    }
  }
}
