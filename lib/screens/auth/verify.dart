import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../utilities/constants.dart';
import '../../controllers/auth_provider.dart';
import '../../main.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  String? enteredCode;
  final pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context);
    String? contact = authService.contact;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: mainColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img1.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: GoogleFonts.poppins(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Enter the verification code sent to\n$contact",
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                controller: pinController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
                showCursor: true,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                  enteredCode = pin;
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                  enteredCode = value;
                  // Perform verification of the entered code here
                },
                validator: (pin) {
                  print(
                      "pin is $pin and code is $enteredCode  htere ${authService.code}");
                  return pin == enteredCode ? null : 'Pin is idcddcdccncorrect';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    onPressed: () async {
                      _showSnackBar(context, "Verification code is incorrect.");
                      if (await authService
                              .signInWithVerificationCode(enteredCode!) !=
                          null) {
                        navigatorKey.currentState!.pushNamed('home');
                        print("Hereeeeeeeeeeeeeeeeeeeeee...........");
                      }
                    },
                    child: Text(
                      "Verify Phone Number",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    )),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   'phone',
                        //   (route) => false,
                        // );
                        navigatorKey.currentState!.pushNamed('phone');
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 100,
                height: 30,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 194, 189, 189),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    onPressed: () async {
                      Navigator.pushNamed(context, 'updateAdvert');
                      print("resend");
                    },
                    child: Text("01:00",
                        style: GoogleFonts.poppins(
                          // fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ))),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}
