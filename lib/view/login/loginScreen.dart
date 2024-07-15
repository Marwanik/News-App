import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/auth/auth_bloc.dart';
import 'package:newsapp/core/bloc/app_manger_bloc.dart';
import 'package:newsapp/model/login_model.dart';
import 'package:newsapp/design/colors.dart';

import 'package:newsapp/widget/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? '';
    usernameController.text = savedUsername;
  }

  Future<void> _saveLoginData(String username, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('token', token);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('token');
    await prefs.setBool('isLoggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: BackGround,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/image/microphone.png",
                        width: 100,
                        height: 100,
                      ),
                      Image.asset(
                        "assets/image/insight.png",
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Column(
                      children: [
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: LabelColor),
                            labelText: 'Username',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 40),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: LabelColor),
                            labelText: 'Email',
                            hintText: "emily.johnson@x.dummyjson.com",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 40),
                        StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return TextField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: LabelColor),
                                border: UnderlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                          color: TextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 20),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is SuccessToLogIn) {
                        _saveLoginData(usernameController.text, 'dummy_token'); // Replace 'dummy_token' with your actual token
                        context.read<AppManagerBloc>().add(HeLoggedIn());
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                      } else if (state is FailedToLogIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please Enter a Correct Username and Password')),
                        );
                      }
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogIn(
                          user: UserModel(
                            username: usernameController.text,
                            password: passwordController.text,
                          ),
                        ));
                      },
                      child: Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor,
                        foregroundColor: IconsWhite,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: LabelColor,
                            height: 30,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Or sign in with",
                            style: TextStyle(
                                color: LabelColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: LabelColor,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/image/google.png"),
                          SizedBox(width: 10,),
                          Text('Continue with Google'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ButtonColor,
                        foregroundColor: TextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/image/facebook.png"),
                          SizedBox(width: 10,),
                          Text('Continue with Facebook'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ButtonColor,
                        foregroundColor: TextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Register",
                          style: TextStyle(color: TextColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
