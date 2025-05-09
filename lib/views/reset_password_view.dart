// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:safecart/services/auth_service/otp_service.dart';
// import 'package:safecart/services/auth_service/reset_password_service.dart';

// import '../helpers/common_helper.dart';
// import '../helpers/empty_space_helper.dart';
// import '../utils/responsive.dart';
// import '../widgets/common/boxed_back_button.dart';
// import '../widgets/common/custom_common_button.dart';
// import '../widgets/common/field_title.dart';
// import 'enter_otp_view.dart';

// class ResetPasswordView extends StatelessWidget {
//   static const routeName = 'reset_password_view';
//   ResetPasswordView({super.key});

//   final GlobalKey<FormState> _formKey = GlobalKey();
//   final _emailController = TextEditingController();

//   trySendingOTP(BuildContext context) async {
//     final valid = _formKey.currentState!.validate();
//     if (!valid) {
//       return;
//     }
//     Provider.of<ResetPasswordService>(context, listen: false)
//         .setEmail(_emailController.text);
//     Provider.of<OtpService>(context, listen: false)
//         .sendOTP(context, _emailController.text)
//         .then((value) {
//       if (value != null) {
//         Navigator.of(context).pop();
//         Navigator.of(context).push(PageRouteBuilder(
//             pageBuilder: (context, animation, anotherAnimation) {
//           return EnterOtpView(value);
//         },
//             // transitionDuration:
//             //     const Duration(milliseconds: 300),
//             transitionsBuilder: (context, animation, anotherAnimation, child) {
//           animation =
//               CurvedAnimation(curve: Curves.decelerate, parent: animation);
//           return Align(
//             child: FadeTransition(
//               opacity: animation,
//               // axisAlignment: 0.0,
//               child: child,
//             ),
//           );
//         }));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: screenHeight / 2.3,
//             width: double.infinity,
//             color: cc.primaryColor,
//           ),
//           CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 elevation: 0,
//                 leadingWidth: 60,
//                 toolbarHeight: 60,
//                 foregroundColor: cc.greyHint,
//                 backgroundColor: Colors.transparent,
//                 pinned: true,
//                 expandedHeight: screenHeight / 3.3,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     height: screenHeight / 3.7,
//                     width: double.infinity,
//                     // padding: EdgeInsets.only(top: screenHeight / 7),
//                     color: cc.primaryColor,
//                     alignment: Alignment.topCenter,
//                     child: Center(
//                       child: Text(
//                         asProvider.getString('Enter your password'),
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(color: cc.pureWhite, fontSize: 25),
//                       ),
//                     ),
//                   ),
//                 ),
//                 leading: Padding(
//                   padding: const EdgeInsets.symmetric(),
//                   child: Column(
//                     children: [
//                       BoxedBackButton(() {
//                         Navigator.of(context).pop();
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     Card(
//                       elevation: 5,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white,
//                         ),
//                         child: Column(
//                           children: [
//                             // AuthAppBar(),
//                             Form(
//                                 key: _formKey,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(20),
//                                   child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         FieldTitle(
//                                             asProvider.getString('Email')),
//                                         TextFormField(
//                                           controller: _emailController,
//                                           decoration: InputDecoration(
//                                             hintText: asProvider
//                                                 .getString('Enter your email'),
//                                             prefixIcon: Padding(
//                                               padding: const EdgeInsets.all(12),
//                                               child: SvgPicture.asset(
//                                                   'assets/icons/profile_prefix.svg'),
//                                             ),
//                                           ),
//                                           validator: (value) {
//                                             if (!EmailValidator.validate(
//                                                 value ?? '')) {
//                                               return asProvider.getString(
//                                                   'Enter a valid email address');
//                                             }
//                                             return null;
//                                           },
//                                           onFieldSubmitted: (value) {
//                                             trySendingOTP(context);
//                                           },
//                                         ),
//                                         EmptySpaceHelper.emptyHight(30),
//                                         Consumer<OtpService>(builder:
//                                             (context, otpProvider, child) {
//                                           return CustomCommonButton(
//                                               btText: asProvider.getString(
//                                                   'Send verification code'),
//                                               isLoading:
//                                                   otpProvider.loadingSendOTP,
//                                               onPressed: () async {
//                                                 FocusScope.of(context)
//                                                     .unfocus();
//                                                 trySendingOTP(context);
//                                               });
//                                         }),
//                                       ]),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/otp_service.dart';
import 'package:safecart/services/auth_service/reset_password_service.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/widgets/common/custom_common_button.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/field_title.dart';
import 'enter_otp_view.dart';

class ResetPasswordView extends StatelessWidget {
  // final String otp;
  // final bool fromRegister;
  // final String phoneNumber; // Required field
  // final TextEditingController controller = TextEditingController();

  static const routeName = 'reset_password_view';
  ResetPasswordView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _phoneController = TextEditingController();

  trySendingOTP(BuildContext context) async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    final phone = _phoneController.text.trim();

    Provider.of<ResetPasswordService>(context, listen: false)
        .setPhone(_phoneController.text);

    final otp = await Provider.of<OtpService>(context, listen: false)
        .sendOTP(context, phone);

    if (otp != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => EnterOtpView(
                  otp,
                  fromRegister: false,
                  phoneNumber: phone,
                )),
      );
    }
    // Provider.of<OtpService>(context, listen: false)
    //     .sendOTP(context, _phoneController.text)
    //     .then((value) {
    //   if (value != null) {
    //     Navigator.of(context).pop();
    //     Navigator.of(context).push(PageRouteBuilder(
    //         pageBuilder: (context, animation, anotherAnimation) {
    //       return EnterOtpView(
    //         value, // This is the otp
    //         fromRegister: false, // Set this appropriately
    //         phoneNumber: _phoneController.text, // Pass the phone number
    //       );
    //     }, transitionsBuilder: (context, animation, anotherAnimation, child) {
    //       // animation =
    //       //     CurvedAnimation(curve: Curves.decelerate, parent: animation);
    //       // return Align(
    //       //   child: FadeTransition(
    //       //     opacity: animation,
    //       //     child: child,
    //       //   ),
    //       // );
    //     }));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
            color: cc.primaryColor,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                leadingWidth: 60,
                toolbarHeight: 60,
                foregroundColor: cc.greyHint,
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: screenHeight / 3.3,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: screenHeight / 3.7,
                    width: double.infinity,
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        asProvider.getString('Reset Password'),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: cc.pureWhite, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Column(
                    children: [
                      BoxedBackButton(() {
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FieldTitle(asProvider
                                            .getString('Phone Number')),
                                        TextFormField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: asProvider.getString(
                                                'Enter your phone number'),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(Icons.phone),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return asProvider.getString(
                                                  'Phone number is required');
                                            }
                                            // Add phone number validation logic here
                                            // Example: Check for minimum length
                                            if (value.length < 10) {
                                              return asProvider.getString(
                                                  'Enter a valid phone number');
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value) {
                                            trySendingOTP(context);
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(30),
                                        Consumer<OtpService>(builder:
                                            (context, otpProvider, child) {
                                          return CustomCommonButton(
                                              btText: asProvider.getString(
                                                  'Send verification code'),
                                              isLoading:
                                                  otpProvider.loadingSendOTP,
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                trySendingOTP(context);
                                              });
                                        }),
                                      ]),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
