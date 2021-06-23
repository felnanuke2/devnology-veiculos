import 'package:devnology_cars_register/controllers/login_controller.dart';
import 'package:devnology_cars_register/repository/login_repository.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController _controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = LoginController(repository: LoginRepository(), scaffoldKey: scaffoldKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          constraints: BoxConstraints(minWidth: 320),
          child: SingleChildScrollView(
              child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                Text(
                  'Gerênciamento de Veículos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: userController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Insira um Usuário Válido';
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Usuário*',
                              prefixIcon: Icon(Icons.person),
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'Insira uma Senha Válida';
                          },
                          decoration: InputDecoration(
                              labelText: 'Senha*',
                              prefixIcon: Icon(Icons.lock),
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder()),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        StreamBuilder<String?>(
                          stream: _controller.errorLoginOutput,
                          builder: (context, snapshotError) {
                            if (snapshotError.data == null) return SizedBox.shrink();
                            return Text(
                              snapshotError.data!,
                              style: TextStyle(color: Colors.red),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 150,
                    height: 45,
                    child: StreamBuilder<bool>(
                        stream: _controller.loginOutput,
                        builder: (context, snapshot) {
                          bool isLoading = snapshot.data == true;
                          return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (!formKey.currentState!.validate()) return;
                                      _controller.login(
                                          userController.text, passwordController.text);
                                    },
                              child: isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Entrar',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ));
                        }),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
