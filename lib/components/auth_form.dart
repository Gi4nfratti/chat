import 'dart:io';
import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void _submit() {
    final _isValid = _formKey.currentState?.validate() ?? false;
    if (!_isValid) return;

    if (_formData.image == null && _formData.isSignup) {
      return _showError('Imagem não selecionada');
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderForm =
        OutlineInputBorder(borderRadius: BorderRadius.circular(5));

    return Column(
      children: [
        Image.asset('assets/images/chatLoginIcon.png',
            height: 80, color: Colors.white),
        SizedBox(height: 50),
        Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_formData.isSignup)
                      UserImagePicker(
                        onImagePick: _handleImagePick,
                      ),
                    if (_formData.isSignup)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          key: ValueKey('name'),
                          initialValue: _formData.name,
                          onChanged: (value) => _formData.name = value,
                          decoration: InputDecoration(
                            border: borderForm,
                            labelText: 'Nome',
                          ),
                          validator: (_name) {
                            final name = _name ?? '';
                            if (name.trim().length < 5) {
                              return 'Nome deve ter no mínimo 5 caracteres.';
                            }
                            return null;
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        key: ValueKey('email'),
                        initialValue: _formData.email,
                        onChanged: (value) => _formData.email = value,
                        decoration: InputDecoration(
                          border: borderForm,
                          labelText: 'E-mail',
                        ),
                        validator: (_email) {
                          final email = _email ?? '';
                          if (!email.contains('@')) {
                            return 'E-mail inválido.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        key: ValueKey('password'),
                        initialValue: _formData.password,
                        onChanged: (value) => _formData.password = value,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: borderForm,
                          labelText: 'Senha',
                        ),
                        validator: (_password) {
                          final password = _password ?? '';
                          if (password.length < 6) {
                            return 'Senha deve ter no mínimo 6 caracteres.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: _submit,
                      child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _formData.toggleAuthMode();
                          });
                        },
                        child: Text(_formData.isLogin
                            ? 'Criar uma nova conta?'
                            : 'Já possui conta?'))
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
