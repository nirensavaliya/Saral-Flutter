import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_String.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/View/HomeView.dart';
import 'package:saral/View/Screen/Login/Controller/LoginController.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          children: [
            Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: 'SHARAL',
                        fontFamily: FontFamily.poppinsRegular,
                        fontSize: 18,
                        color: Color(0xffC8102E),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: 'WelCome Back',
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 25,
                        color: Color(0xffC8102E),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CommonText(
                            text:
                            'Sign in to continue ordering your\nfavourite meals.',
                            fontFamily: FontFamily.poppinsSemiBold,
                            textAlign: TextAlign.center,
                            fontSize: 17,
                            color: Color(0xffC8102E),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F8FC),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.18),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          controller: loginController.tabController,
                          indicator: BoxDecoration(
                            color: Color(0xffC8102E),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(text: "Login"),
                            Tab(text: "Sign Up"),
                          ],
                        ),
                      ),
                      Expanded(
                        // height: MediaQuery.of(context).size.height * 0.90,
                        // margin: EdgeInsets.only(top: 10),
                        child: TabBarView(
                          controller: loginController.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          clipBehavior: Clip.none,
                          children: [
                            SingleChildScrollView(
                              child: Form(
                                key: loginController.loginKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    // CommonTextField(
                                    //   isTitle: true,
                                    //   title: AppString.enterUser,
                                    //   textCapitalization: TextCapitalization.words,
                                    //   textInputType: TextInputType.text,
                                    //   hintText: "+91 4657 43546",
                                    //   prefix: Icon(Icons.call),
                                    //   textInputAction: TextInputAction.next,
                                    //   validator: (value) {
                                    //     if (value == null || value.isEmpty) {
                                    //       return "User Name is required.";
                                    //     }
                                    //     return null;
                                    //   },
                                    //   controller: loginController.userNameController,
                                    // ),
                                    // SizedBox(height: 10),
                                    // Obx(
                                    //       () => CommonTextField(
                                    //     isTitle: true,
                                    //     title: "Password",
                                    //     controller: loginController.pwdController,
                                    //     textInputType: TextInputType.visiblePassword,
                                    //     hintText: "*****",
                                    //     obscureText: !loginController.isPasswordVisible.value,
                                    //     prefix: const Icon(Icons.lock),
                                    //     suffix: IconButton(
                                    //       icon: Icon(
                                    //         loginController.isPasswordVisible.value
                                    //             ? Icons.visibility
                                    //             : Icons.visibility_off,
                                    //       ),
                                    //       onPressed: () {
                                    //         loginController.isPasswordVisible.toggle();
                                    //       },
                                    //     ),
                                    //     validator: (value) {
                                    //       if (value == null || value.isEmpty) {
                                    //         return "Password is required.";
                                    //       }
                                    //       return null;
                                    //     },
                                    //   ),
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //   MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Row(
                                    //       mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //       children: [
                                    //         Checkbox(
                                    //           value: false,
                                    //           onChanged: (value) {},
                                    //         ),
                                    //         CommonText(
                                    //           text: 'Remember me',
                                    //           fontFamily:
                                    //           FontFamily.poppinsRegular,
                                    //           fontSize: 12,
                                    //           color: Colors.black,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     CommonText(
                                    //       text: 'Forgot Password?',
                                    //       fontFamily: FontFamily.poppinsRegular,
                                    //       fontSize: 12,
                                    //       color: Colors.red,
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(height: 20),
                                    // CommonButton(
                                    //     btnName: loginController.isLoading.value
                                    //       ? "Please wait..."
                                    //       : "Login",
                                    //   onTap: loginController.isLoading.value
                                    //       ? null
                                    //       : () async {
                                    //
                                    //     if (loginController
                                    //         .loginKey.currentState!
                                    //         .validate()) {
                                    //       await loginController.login(context);
                                    //     }
                                    //   },
                                    // ),
                                    // SizedBox(height: 20),
                                    // CommonText(text: "Are you a Customer?",fontFamily: FontFamily.poppinsMedium,),
                                    Obx(() {
                                      if (loginController.isCustomer.value) {
                                        // Customer Login
                                        return Column(
                                          children: [
                                            CommonTextField(
                                              isTitle: true,
                                              title: "Mobile Number",
                                              controller: loginController.mobileController,
                                              textInputType: TextInputType.phone,
                                              hintText: "Enter Mobile Number",
                                              textInputAction: TextInputAction.done,
                                              prefix: const Icon(Icons.call),
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
                                      SizedBox(height: 40,),
                                      CommonButton(
                                          btnName: loginController.isLoading.value
                                            ? "Please wait..."
                                            : "Login",
                                        onTap: loginController.isLoading.value
                                            ? null
                                            : () async {

                                          if (loginController
                                              .loginKey.currentState!
                                              .validate()) {
                                            Global().hideKeyboard();
                                            await loginController.apiSelectCompany();
                                            await loginController.customerLogin(context);
                                          }
                                        },
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
                                            prefix: const Icon(Icons.person),
                                            textInputAction: TextInputAction.next,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "User Name is required.";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Obx(
                                                () => CommonTextField(
                                              isTitle: true,
                                              title: "Password",
                                              controller: loginController.pwdController,
                                                  textInputAction: TextInputAction.done,

                                                  obscureText: !loginController.isPasswordVisible.value,
                                              hintText: "*****",
                                              prefix: const Icon(Icons.lock),
                                              suffix: IconButton(
                                                icon: Icon(
                                                  loginController.isPasswordVisible.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
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
                                          SizedBox(height: 30,),
                                          CommonButton(
                                            btnName: loginController.isLoading.value
                                                ? "Please wait..."
                                                : "Login",
                                            onTap: loginController.isLoading.value
                                                ? null
                                                : () async {

                                              if (loginController
                                                  .loginKey.currentState!
                                                  .validate()) {
                                                Global().hideKeyboard();
                                                await loginController.apiSelectCompany();
                                                await loginController.userLogin(context);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    }),
                                    SizedBox(height: 30,),
                                    Obx(
                                          () => GestureDetector(
                                        onTap: () {
                                          loginController.isCustomer.toggle();
                                          loginController.resetLoginData();
                                        },
                                        child: CommonText(
                                          text: loginController.isCustomer.value
                                              ? "Are you an Employee?"
                                              : "Are you a Customer?",
                                          fontFamily: FontFamily.poppinsBold,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 30,),

                                    // OTP Input Section with Auto-fill
                                    Obx(() {
                                      if (loginController.showOtpScreen.value) {
                                        return Column(
                                          children: [
                                            CommonText(
                                              text: "OTP",
                                              fontSize: 16,
                                              fontFamily: FontFamily.poppinsBold,
                                            ),
                                            SizedBox(height: 7,),
                                            Pinput(
                                              controller: loginController.otpController,
                                              length: 5,
                                              keyboardType: TextInputType.number,
                                              onChanged: (value) {
                                                loginController.otp = value;
                                              },
                                              onCompleted: (value) {
                                                loginController.otp = value;
                                              },
                                              defaultPinTheme: PinTheme(
                                                width: 50,
                                                height: 55,
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              focusedPinTheme: PinTheme(
                                                width: 50,
                                                height: 55,
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blue, width: 2),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            // CommonTextField(
                                            //   isTitle: true,
                                            //   controller: loginController.otpController,
                                            //   borderRadius: 8,
                                            //   hintText: "Enter OTP",
                                            //   title: "OTP",
                                            //   textInputAction: TextInputAction.done,
                                            //   onChanged: (value) {
                                            //     loginController.otp = value;
                                            //   },
                                            // ),
                                            Gap(10),
                                            Row(
                                              children: [
                                                Icon(
                                                  loginController.isListeningForOtp.value
                                                      ? Icons.check_circle
                                                      : Icons.error,
                                                  color: loginController.isListeningForOtp.value
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  size: 16,
                                                ),
                                                const Gap(5),
                                                Text(
                                                  loginController.isListeningForOtp.value
                                                      ? "Listening for OTP messages..."
                                                      : "OTP auto-fill not available",
                                                ),
                                              ],
                                            ),

                                            const Gap(20),

                                            Obx(
                                                  () => CommonButton(
                                                btnName: loginController.isVerifyOtpLoading.value
                                                    ? "Please wait..."
                                                    : "Verify OTP",
                                                onTap: loginController.isVerifyOtpLoading.value
                                                    ? null
                                                    : () {
                                                  if (loginController.otpController.text.trim().isNotEmpty) {
                                                    loginController.verifyOtp(
                                                      loginController.otpController.text.trim(),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return const SizedBox();
                                    }),

                                    // if (loginController.showOtpScreen.value)
                                    //   Gap(20),
                                    // if (loginController.showOtpScreen.value)
                                    //   CommonButton(
                                    //     btnName: "Verify OTP",
                                    //     onTap: () {
                                    //       if (loginController.otpController.text.trim().isNotEmpty) {
                                    //         loginController.verifyOtp(loginController.otpController.text.trim());
                                    //       } else {
                                    //         Utils().showToast(
                                    //           context: Get.context!,
                                    //           title: "",
                                    //           message: "Please enter OTP",
                                    //           isSuccess: true,
                                    //         );
                                    //       }
                                    //     },
                                    //   ),
                                    Gap(2),
                                    SizedBox(height: 30),
                                    // RichText(
                                    //   text: TextSpan(
                                    //     children: [
                                    //       TextSpan(
                                    //         text: "Don't have an account? ",
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 14,
                                    //         ),
                                    //       ),
                                    //       TextSpan(
                                    //         text: "Create an Account",
                                    //         style: TextStyle(
                                    //           color: Colors.red,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //         recognizer: TapGestureRecognizer()
                                    //           ..onTap = () {
                                    //             loginController.tabController.animateTo(1);
                                    //           },
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Form(
                                key:loginController.signupKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    CommonTextField(
                                      isTitle: true,
                                      title: AppString.enterUser,
                                      textCapitalization:
                                      TextCapitalization.words,
                                      textInputType: TextInputType.text,
                                      prefix: Icon(Icons.call),
                                      hintText: "+91 34555",
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Contact Number is required.";
                                        }
                                        return null;
                                      },
                                      controller:
                                      loginController.signContactController,
                                    ),
                                    SizedBox(height: 10),
                                    Obx(
                                          () => CommonTextField(
                                        isTitle: true,
                                        title: "Password",
                                        controller: loginController.signPwdController,
                                        textInputType: TextInputType.visiblePassword,
                                        obscureText: !loginController.isPasswordVisible.value,
                                        prefix: const Icon(Icons.lock),
                                        hintText: "*****",
                                        suffix: IconButton(
                                          icon: Icon(
                                            loginController.isPasswordVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
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
                                    SizedBox(height: 10),
                                    Obx(
                                          () => CommonTextField(
                                        isTitle: true,
                                        title: "Password",
                                        controller: loginController.signCPwdController,
                                        textInputType: TextInputType.visiblePassword,
                                            hintText: "*****",
                                        obscureText: !loginController.isConfirmPasswordVisible.value,
                                        prefix: const Icon(Icons.lock),
                                        suffix: IconButton(
                                          icon: Icon(
                                            loginController.isConfirmPasswordVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
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
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (value) {},
                                            ),
                                            CommonText(
                                              text: 'Remember me',
                                              fontFamily:
                                              FontFamily.poppinsRegular,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        CommonText(
                                          text: 'Forgot Password?',
                                          fontFamily: FontFamily.poppinsRegular,
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    CommonButton(
                                      btnName: "Submit",
                                      onTap: (){
                                        Get.offAllNamed(AppRoutes.dashboardScreen);
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Divider(
                                            color: Colors.black,
                                            thickness: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        CommonText(
                                          text: 'Or Continue With',
                                          fontFamily: FontFamily.poppinsRegular,
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Divider(
                                            color: Colors.black,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),

                                   GestureDetector(
                                            child: Container(
                                              height: 65,
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(15),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/google.png',
                                                    height: 28,
                                                    width: 28,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    'Google',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                    SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Already have an account? ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: FontFamily.poppinsRegular,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Login",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                loginController.tabController.animateTo(0);
                                              },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),


        ]
      ),
    );
  }
}
