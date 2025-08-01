import 'package:donor/Firebase/otp.dart';
import 'package:donor/Theme/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:donor/Widgets/textbox.dart';

class LoginPage extends StatefulWidget {
  final bool fromRegister;
  final bool otpVisible;
  final String? verificationId;

  const LoginPage({
    super.key,
    this.fromRegister = false,
    this.otpVisible = false,
    this.verificationId,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  late bool otpVisible;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    otpVisible = widget.otpVisible;
    if (widget.verificationId != null) {
      _verificationId = widget.verificationId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                widget.fromRegister ? "Verification" : "Login",
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "We'll send you an OTP to verify your number.",
                style: TextStyle(
                  fontSize: 20,
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 50),
              Divider(thickness: 2, color: context.colorScheme.onSurface),
              const SizedBox(height: 50),

              /// PHONE INPUT
              Row(
                children: [
                  Container(
                    width: screenWidth / 5.5,
                    height: 57,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+91',
                        style: TextStyle(
                          fontSize: 18,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextBox(
                      readOnly: otpVisible ? true : false,
                      controller: phoneController,
                      maxLenght: 10,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),

              /// OTP INPUT
              Visibility(
                visible: otpVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: TextBox(
                    controller: otpController,
                    maxLenght: 6,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              /// SUBMIT BUTTON
              GestureDetector(
                onTap: () {
                  final phone = phoneController.text.trim();

                  if (!otpVisible) {
                    if (phone.isEmpty || phone.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Check phone number')),
                      );
                    } else {
                      OtpService.sendOtp(
                        fromRegister: widget.fromRegister,
                        context: context,
                        phoneNumber: phone,
                        onCodeSent: (verificationId) {
                          setState(() {
                            Navigator.pop(context);
                            otpVisible = true;
                            _verificationId = verificationId;
                          });
                        },
                      );
                    }
                  } else {
                    if (otpController.text.length == 6) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                      OtpService.verifyOtp(
                        fromRegister: widget.fromRegister,
                        context: context,
                        verificationId: _verificationId,
                        otp: otpController.text.trim(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please check OTP')),
                      );
                    }
                  }
                },

                child: Container(
                  width: screenWidth,
                  height: 56.6,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      otpVisible ? 'Continue' : 'Send OTP',
                      style: TextStyle(
                        fontSize: 18,
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
