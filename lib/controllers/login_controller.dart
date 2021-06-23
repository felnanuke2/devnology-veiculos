import 'dart:async';

import 'package:devnology_cars_register/views/dashboard_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:devnology_cars_register/repository/login_repository.dart';
import 'package:get/route_manager.dart';

class LoginController {
  final LoginRepository repository;
  final GlobalKey<ScaffoldState> scaffoldKey;
  LoginController({
    required this.repository,
    required this.scaffoldKey,
  });
  var _loginController = StreamController<bool>.broadcast();
  var _errorController = StreamController<String?>.broadcast();

  Stream<bool> get loginOutput => _loginController.stream;
  Stream<String?> get errorLoginOutput => _errorController.stream;

  login(String email, String password) async {
    _loginController.add(true);
    var result = await repository.login(email, password);
    _loginController.add(false);
    _errorController.add(result);
    if (result == null) {
      Get.offAll(() => DashBoardScreen());
    }
  }
}
