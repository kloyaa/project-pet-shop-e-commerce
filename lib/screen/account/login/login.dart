import 'package:app/common/destroyTextFieldFocus.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _user = Get.put(UserController());

  late TextEditingController _emailController;
  late FocusNode _emailFocus;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocus;

  bool _obscureText = true;
  bool _hasError = false;

  Future<void> onLogin() async {
    try {
      final _email = _emailController.text.trim();
      final _password = _passwordController.text.trim();

      // VALIDATE
      if (_email.isEmpty) return _emailFocus.requestFocus();
      if (_password.isEmpty) return _passwordFocus.requestFocus();

      await _user.login(email: _email, password: _password);

      setState(() {
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      if (kDebugMode) {
        print("onLogin()");
      }
    }
  }

  void onNavigate() {
    Get.toNamed("/register");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocus = FocusNode();

    _emailController.text = "madridano.kolya@gmail.com";
    _passwordController.text = "password";
    // _emailController.text = "historia@gmail.com";
    // _passwordController.text = "password";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "Account Login",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kLight,
      ),
    );
    final _subTitle = Text(
      "Please enter your Email and Password.",
      style: GoogleFonts.chivo(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: kLight,
      ),
    );
    final _registerAccount = Container(
      margin: const EdgeInsets.only(top: 25.0),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => onNavigate(),
        behavior: HitTestBehavior.opaque,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Don't have an account?",
            style: GoogleFonts.roboto(
              color: kLight,
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: " SIGN UP!",
                style: GoogleFonts.roboto(
                  color: kLight,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
    final _errorMessage = Container(
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: kDefaultRadius,
      ),
      margin: const EdgeInsets.only(top: 15.0, bottom: 15),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            AntDesign.warning,
            color: kLight,
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Text(
              "Email and/or password you have  \nentered is incorrect.",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kLight,
              ),
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kPrimary,
          body: Container(
            padding: kDefaultBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70.0),
                _title,
                _subTitle,
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 30.0),
                  child: inputTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    color: kLight,
                    hasError: _hasError,
                    labelText: "Email",
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                    hintStyleStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: _obscureText,
                    color: kLight,
                    hasError: _hasError,
                    labelText: "Password",
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                    hintStyleStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: CheckboxListTile(
                    value: _obscureText,
                    onChanged: (v) {
                      setState(() {
                        _obscureText = v as bool;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Hide Password",
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kLight,
                      ),
                    ),
                  ),
                ),
                _hasError ? _errorMessage : const SizedBox(),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: TextButton(
                    onPressed: () => onLogin(),
                    style: TextButton.styleFrom(
                      //primary: kFadeWhite,
                      backgroundColor: kSecondary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                    child: Text(
                      "LOG IN",
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: kLight,
                      ),
                    ),
                  ),
                ),
                _registerAccount,
                const SizedBox(height: 70.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
