import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dynamodb_service.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _faceIdEnabled = false;
  final DynamoDBService _dynamoDBService = DynamoDBService();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadFaceIdPreference();
  }

  Future<void> _loadFaceIdPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _faceIdEnabled = prefs.getBool('face_id_enabled') ?? false;
      if (_faceIdEnabled) {
        _authenticateWithBiometrics();
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        Navigator.pushReplacementNamed(context, '/foodLog');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric authentication failed';
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool userExists = await _dynamoDBService.authenticateUser(email, password);

    if (userExists) {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('face_id_enabled') ?? false;
      if (!enabled) {
        bool canCheckBiometrics = await auth.canCheckBiometrics;
        if (canCheckBiometrics) {
          final enable = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Enable Face ID?'),
              content: Text('Would you like to use Face ID for future logins?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Yes'),
                ),
              ],
            ),
          );
          if (enable == true) {
            await prefs.setBool('face_id_enabled', true);
          }
        }
      }
      Navigator.pushReplacementNamed(context, '/foodLog');
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_faceIdEnabled)
                ElevatedButton.icon(
                  icon: Icon(Icons.face),
                  label: Text('Login with Face ID'),
                  onPressed: _authenticateWithBiometrics,
                ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: 16),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: Text('Login'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registration');
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}