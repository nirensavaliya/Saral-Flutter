import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_String.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Login/Controller/LoginController.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());

  static const Color _sheetBg = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (loginController.showOtpScreen.value) {
        return _buildOtpUi(context);
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: _buildLoginUi(context)),
      );
    });
  }

  // ─── LOGIN ───────────────────────────────────────────────

  Widget _buildLoginUi(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
          child: Center(
            child: Image.asset(
              AppImages.withOutBgAppLogo,
              height: 180,
              width: double.infinity,
              // width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            decoration: BoxDecoration(
              color: _sheetBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildAuthTabs(),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    controller: loginController.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildLoginTab(context),
                      _buildSignUpTab(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthTabs() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TabBar(
        controller: loginController.tabController,
        indicator: BoxDecoration(
          color: AppColors.brandRed,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandRed.withValues(alpha: 0.28),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        labelStyle: TextStyle(
          fontFamily: FontFamily.poppinsSemiBold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: FontFamily.poppinsMedium,
          fontSize: 14,
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: "Login"),
          Tab(text: "Sign Up"),
        ],
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 20),
      child: Form(
        key: loginController.loginKey,
        child: Column(
          children: [
            Obx(() {
              if (loginController.isCustomer.value) {
                return Column(
                  children: [
                    CommonTextField(
                      isTitle: true,
                      title: "Mobile Number",
                      controller: loginController.mobileController,
                      textInputType: TextInputType.phone,
                      hintText: "Enter Mobile Number",
                      textInputAction: TextInputAction.done,
                      borderRadius: 14,
                      prefix: const Icon(Icons.call_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mobile Number is required.";
                        }
                        if (value.length != 10) {
                          return "Enter valid Mobile Number.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => CommonButton(
                        btnName: loginController.isLoading.value
                            ? "Please wait..."
                            : "Login",
                        onTap: loginController.isLoading.value
                            ? null
                            : () async {
                                if (loginController.loginKey.currentState!
                                    .validate()) {
                                  Global().hideKeyboard();
                                  await loginController
                                      .customerLogin(context);
                                }
                              },
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  CommonTextField(
                    isTitle: true,
                    title: AppString.enterUser,
                    controller: loginController.userNameController,
                    hintText: "Enter User Name",
                    borderRadius: 14,
                    prefix: const Icon(Icons.person_outline_rounded),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "User Name is required.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => CommonTextField(
                      isTitle: true,
                      title: "Password",
                      controller: loginController.pwdController,
                      textInputAction: TextInputAction.done,
                      obscureText:
                          !loginController.isPasswordVisible.value,
                      hintText: "*****",
                      borderRadius: 14,
                      prefix: const Icon(Icons.lock_outline_rounded),
                      suffix: IconButton(
                        icon: Icon(
                          loginController.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          loginController.isPasswordVisible.toggle();
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required.";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  Obx(
                    () => CommonButton(
                      btnName: loginController.isLoading.value
                          ? "Please wait..."
                          : "Login",
                      onTap: loginController.isLoading.value
                          ? null
                          : () async {
                              if (loginController.loginKey.currentState!
                                  .validate()) {
                                Global().hideKeyboard();
                                await loginController.userLogin(context);
                              }
                            },
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 28),
            Obx(
              () => GestureDetector(
                onTap: () {
                  loginController.isCustomer.toggle();
                  loginController.resetLoginData();
                },
                child: Text(
                  loginController.isCustomer.value
                      ? "Are you an Employee?"
                      : "Are you a Customer?",
                  style: TextStyle(
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 14,
                    color: AppColors.brandRed,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.brandRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOtpUi(BuildContext context) {
    final pinTheme = PinTheme(
      width: 54,
      height: 58,
      textStyle: TextStyle(
        fontSize: 22,
        fontFamily: FontFamily.poppinsSemiBold,
        color: Colors.black87,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "Verify OTP",
        showDrawer: false,
        showBackButton: true,
        onBack: loginController.resetLoginData,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.brandRed.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sms_outlined,
                          color: AppColors.brandRed,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 18),
                      CommonText(
                        text:
                            'Enter the 5-digit code we sent to\nyour registered mobile number',
                        fontFamily: FontFamily.poppinsRegular,
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        height: 1.4,
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CommonText(
                          text: "OTP",
                          fontSize: 15,
                          fontFamily: FontFamily.poppinsSemiBold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Pinput(
                        controller: loginController.otpController,
                        length: 5,
                        keyboardType: TextInputType.number,
                        separatorBuilder: (index) => const SizedBox(width: 10),
                        onChanged: (value) => loginController.otp = value,
                        onCompleted: (value) => loginController.otp = value,
                        defaultPinTheme: pinTheme,
                        focusedPinTheme: pinTheme.copyWith(
                          decoration: pinTheme.decoration!.copyWith(
                            border: Border.all(
                              color: AppColors.brandRed,
                              width: 2,
                            ),
                          ),
                        ),
                        submittedPinTheme: pinTheme.copyWith(
                          decoration: pinTheme.decoration!.copyWith(
                            border: Border.all(
                              color: AppColors.brandRed,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: loginController.isListeningForOtp.value
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                loginController.isListeningForOtp.value
                                    ? Icons.check_circle_rounded
                                    : Icons.info_outline_rounded,
                                color: loginController.isListeningForOtp.value
                                    ? Colors.green.shade600
                                    : Colors.grey.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                loginController.isListeningForOtp.value
                                    ? "Listening for OTP..."
                                    : "Waiting for OTP",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontFamily.poppinsMedium,
                                  color: loginController.isListeningForOtp.value
                                      ? Colors.green.shade700
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      CommonButton(
                        btnName: "Verify OTP",
                        onTap: () {
                          final otp =
                              loginController.otpController.text.trim();
                          if (otp.isEmpty || otp.length < 5) {
                            Utils().showToast(
                              context: context,
                              title: "Error",
                              message: "Please enter complete OTP",
                              isSuccess: false,
                            );
                            return;
                          }
                          Global().hideKeyboard();
                          loginController.verifyOtp(otp, context: context);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          Global().hideKeyboard();
                          await loginController.apiCallSendOtp(context);
                        },
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontFamily: FontFamily.poppinsSemiBold,
                            fontSize: 14,
                            color: AppColors.brandRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() {
              if (!loginController.isVerifyOtpLoading.value) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: Material(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Lottie.asset(
                        'assets/lottie/app_loader.json',
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── SIGN UP ─────────────────────────────────────────────

  Widget _buildSignUpTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 20),
      child: Form(
        key: loginController.signupKey,
        child: Column(
          children: [
            CommonTextField(
              isTitle: true,
              title: AppString.enterUser,
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.text,
              prefix: const Icon(Icons.call_outlined),
              hintText: "+91 34555",
              borderRadius: 14,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Contact Number is required.";
                }
                return null;
              },
              controller: loginController.signContactController,
            ),
            const SizedBox(height: 14),
            Obx(
              () => CommonTextField(
                isTitle: true,
                title: "Password",
                controller: loginController.signPwdController,
                textInputType: TextInputType.visiblePassword,
                obscureText: !loginController.isPasswordVisible.value,
                prefix: const Icon(Icons.lock_outline_rounded),
                hintText: "*****",
                borderRadius: 14,
                suffix: IconButton(
                  icon: Icon(
                    loginController.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    loginController.isPasswordVisible.toggle();
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required.";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CommonTextField(
                isTitle: true,
                title: "Confirm Password",
                controller: loginController.signCPwdController,
                textInputType: TextInputType.visiblePassword,
                hintText: "*****",
                borderRadius: 14,
                obscureText:
                    !loginController.isConfirmPasswordVisible.value,
                prefix: const Icon(Icons.lock_outline_rounded),
                suffix: IconButton(
                  icon: Icon(
                    loginController.isConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    loginController.isConfirmPasswordVisible.toggle();
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm Password is required.";
                  }
                  if (value != loginController.signPwdController.text) {
                    return "Password and Confirm Password do not match.";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 28),
            CommonButton(
              btnName: "Submit",
              onTap: () {
                Get.offAllNamed(AppRoutes.dashboardScreen);
              },
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontFamily: FontFamily.poppinsRegular,
                    ),
                  ),
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                      color: AppColors.brandRed,
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 13,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        loginController.tabController.animateTo(0);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
