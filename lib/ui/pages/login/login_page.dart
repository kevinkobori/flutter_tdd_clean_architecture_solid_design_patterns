import 'package:flutter/material.dart';

import '../../components/component.dart';

import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({this.presenter});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.mainErrorStream.listen((error) {
            if (error != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red[900],
                content: Text(error, textAlign: TextAlign.center),
              ));
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginHeader(),
                SizedBox(
                  height: 32,
                ),
                Headline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    child: Column(
                      children: [
                        StreamBuilder<String>(
                            stream: widget.presenter.emailErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  icon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: widget.presenter.validateEmail,
                              );
                            }),
                        SizedBox(height: 8),
                        StreamBuilder<String>(
                            stream: widget.presenter.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  icon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                ),
                                obscureText: true,
                                onChanged: widget.presenter.validatePassword,
                              );
                            }),
                        SizedBox(height: 32),
                        StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return RaisedButton(
                                onPressed: snapshot.data == true
                                    ? widget.presenter.auth
                                    : null,
                                child: Text(
                                  'Entrar'.toUpperCase(),
                                ),
                              );
                            }),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: Text(
                        //     'Entrar'.toUpperCase(),
                        //   ),
                        // ),
                        FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                          label: Text('Criar Conta'),
                        )
                        // TextButton(
                        //   onPressed: () {},
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Icon(Icons.person),
                        //       SizedBox(
                        //         width: 8,
                        //       ),
                        //       Text('Criar Conta'),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
