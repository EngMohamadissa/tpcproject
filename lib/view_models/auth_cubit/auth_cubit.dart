import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/view_models/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SharedPreferences sharedPreferences;
  AuthCubit(this.sharedPreferences) : super(AuthInitial());
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> logIn() async {
    emit(Loading());
    try {
      log(email.text);
      log('2');

      final response = await ApiService().post(
        'login',
        {
          "email": email.text,
          "password": password.text,
        },
      );
      final data = response.data;
      final pref = await SharedPreferences.getInstance();
      await pref.setString('auth_token', data['token']);
      log('statuscode ${response.statusCode}');
      final decodedResponse = json.decode(response.data);
      log('statuscode2 ${decodedResponse["status"]}');
      if (decodedResponse["status"] == 200) {
        log(decodedResponse.toString());
        emit(LoginSucces());
      } else {
        log('=====================00===');
        emit(LoginError(error: "${decodedResponse["message"]}"));
      }
    } catch (e) {
      log("===============${e.toString()}");
    }
  }

  Future<void> register({required String user_role}) async {
    emit(Loading());
    try {
      log(email.text);
      final url = Uri.parse("http://10.0.2.2:8000/api/register");

      log(password.text);
      log(name.text);
      log(phone.text);
      final response = await http.post(
        url,
        body: {
          "name": name.text,
          "email": email.text,
          "password": password.text,
          "phone": phone.text,
          "user_role": user_role,
        },
        headers: {"Accept": "application/json"},
      );
      log('statuscode ${response.statusCode}');
      final decodedResponse = json.decode(response.body);
      log('statuscode2 ${decodedResponse["status"]}');
      if (decodedResponse["status"] == 201) {
        log(decodedResponse.toString());
        emit(SignUpSucces());
      } else {
        log('========================');
        emit(SignUpError(error: "${decodedResponse["message"]}"));
      }
    } catch (e) {
      log("==============000000=${e.toString()}");
    }
  }
}
