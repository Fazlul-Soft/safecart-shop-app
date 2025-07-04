// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:safecart/services/auth_service/sign_up_service.dart';
// import 'package:safecart/services/auth_service/social_signin_signup_service.dart';
// import 'package:safecart/utils/custom_preloader.dart';
// import 'package:safecart/utils/responsive.dart';

// import '../helpers/common_helper.dart';
// import '../helpers/empty_space_helper.dart';
import '../services/auth_service/save_sign_in_info_service.dart';
// import '../services/auth_service/sign_in_service.dart';
// import '../widgets/common/boxed_back_button.dart';
// import '../widgets/common/custom_common_button.dart';
// import '../widgets/common/field_title.dart';
// import '../widgets/common/horizontal_or_divider.dart';
import 'reset_password_view.dart';
import 'sign_up_view.dart';

// class SignInView extends StatelessWidget {
//   static const routeName = 'sign_in_view';
//   SignInView({super.key});

//   final GlobalKey<FormState> _formKey = GlobalKey();
//   final TextEditingController _emailUsernameController =
//       TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   trySignIn(BuildContext context) {
//     final valid = _formKey.currentState!.validate();
//     if (!valid) {
//       return;
//     }
//     Provider.of<SignInService>(context, listen: false).signIn(
//         context, _emailUsernameController.text, _passwordController.text);
//   }

//   initMailPass(BuildContext context) {
//     if (!onceInit) {
//       onceInit = true;
//       _emailUsernameController.text =
//           Provider.of<SaveSignInInfoService>(context, listen: false)
//                   .emailUsername ??
//               '';
//       _passwordController.text =
//           Provider.of<SaveSignInInfoService>(context, listen: false).password ??
//               '';
//     }
//   }

//   bool onceInit = false;

//   @override
//   Widget build(BuildContext context) {
//     initMailPass(context);

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
//                         asProvider.getString('Welcome Back'),
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
//                           // padding: EdgeInsets.zero,
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
//                                         FieldTitle(asProvider
//                                             .getString('Phone/Email')),
//                                         TextFormField(
//                                           controller: _emailUsernameController,
//                                           textInputAction: TextInputAction.next,
//                                           decoration: InputDecoration(
//                                             hintText: asProvider.getString(
//                                                 'Enter your phone or email'),
//                                             prefixIcon: Padding(
//                                               padding: const EdgeInsets.all(12),
//                                               child: SvgPicture.asset(
//                                                   'assets/icons/profile_prefix.svg'),
//                                             ),
//                                           ),
//                                           validator: (value) {
//                                             if (value == null ||
//                                                 value.isEmpty ||
//                                                 value.trim().isEmpty) {
//                                               return asProvider.getString(
//                                                   'Enter your phone or email');
//                                             }
//                                             return null;
//                                           },
//                                         ),
//                                         EmptySpaceHelper.emptyHight(10),
//                                         FieldTitle(
//                                             asProvider.getString('Password')),
//                                         Consumer<SignInService>(builder:
//                                             (context, siProvider, child) {
//                                           return TextFormField(
//                                             controller: _passwordController,
//                                             obscureText:
//                                                 siProvider.obscurePassword,
//                                             decoration: InputDecoration(
//                                               hintText: asProvider.getString(
//                                                   'Enter your Password'),
//                                               prefixIcon: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(12),
//                                                 child: SvgPicture.asset(
//                                                     'assets/icons/pass_prefix.svg'),
//                                               ),
//                                               suffixIcon: GestureDetector(
//                                                 onTap: () {
//                                                   siProvider
//                                                       .setObscurePassword(null);
//                                                 },
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(12),
//                                                   child: SvgPicture.asset(
//                                                     'assets/icons/${siProvider.obscurePassword ? 'obscure_on' : 'obscure_off'}.svg',
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty ||
//                                                   value.trim().isEmpty ||
//                                                   value.length < 6) {
//                                                 return asProvider.getString(
//                                                     'Password must be more then 6 character');
//                                               }
//                                               return null;
//                                             },
//                                             onFieldSubmitted: (value) {
//                                               FocusScope.of(context).unfocus();
//                                               trySignIn(context);
//                                             },
//                                           );
//                                         }),
//                                         EmptySpaceHelper.emptyHight(10),
//                                         Row(
//                                           children: [
//                                             Consumer<SignInService>(builder:
//                                                 (context, siProvider, child) {
//                                               return Transform.scale(
//                                                 scale: 1.3,
//                                                 child: Checkbox(
//                                                   value: siProvider
//                                                       .rememberPassword,
//                                                   onChanged: (value) {
//                                                     siProvider
//                                                         .setRememberPassword(
//                                                             value);
//                                                   },
//                                                 ),
//                                               );
//                                             }),
//                                             ConstrainedBox(
//                                               constraints: BoxConstraints(
//                                                   maxWidth: screenWidth / 4.5),
//                                               // width: screenWidth / 3,
//                                               child: FittedBox(
//                                                 child: Text(
//                                                   asProvider
//                                                       .getString('Remember me'),
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .titleSmall!
//                                                       .copyWith(
//                                                           fontWeight: FontWeight
//                                                               .normal),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Spacer(),
//                                             ConstrainedBox(
//                                               constraints: BoxConstraints(
//                                                   maxWidth: screenWidth / 3.2),
//                                               child: FittedBox(
//                                                 child: TextButton(
//                                                   onPressed: () {
//                                                     FocusScope.of(context)
//                                                         .unfocus();
//                                                     Navigator.of(context).push(
//                                                         PageRouteBuilder(
//                                                             pageBuilder: (context,
//                                                                 animation,
//                                                                 anotherAnimation) {
//                                                               return ResetPasswordView();
//                                                             },
//                                                             reverseTransitionDuration:
//                                                                 const Duration(
//                                                                     microseconds:
//                                                                         10),
//                                                             // transitionDuration:
//                                                             //     const Duration(milliseconds: 300),
//                                                             transitionsBuilder:
//                                                                 (context,
//                                                                     animation,
//                                                                     anotherAnimation,
//                                                                     child) {
//                                                               animation = CurvedAnimation(
//                                                                   curve: Curves
//                                                                       .decelerate,
//                                                                   parent:
//                                                                       animation);
//                                                               return Align(
//                                                                 child:
//                                                                     FadeTransition(
//                                                                   opacity:
//                                                                       animation,
//                                                                   // axisAlignment: 0.0,
//                                                                   child: child,
//                                                                 ),
//                                                               );
//                                                             }));
//                                                   },
//                                                   // style: ButtonStyle(
//                                                   //     overlayColor: MaterialStateColor.resolveWith(
//                                                   //         (states) => Colors.transparent)),
//                                                   child: Text(
//                                                     asProvider.getString(
//                                                         'Forgot password?'),
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .titleSmall!
//                                                         .copyWith(
//                                                           color:
//                                                               cc.secondaryColor,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         EmptySpaceHelper.emptyHight(10),
//                                         Consumer<SignInService>(builder:
//                                             (context, siProvider, child) {
//                                           return CustomCommonButton(
//                                               btText: asProvider
//                                                   .getString('Sign In'),
//                                               isLoading:
//                                                   siProvider.loadingSignIn,
//                                               onPressed: () {
//                                                 FocusScope.of(context)
//                                                     .unfocus();
//                                                 trySignIn(context);
//                                               });
//                                         }),
//                                         EmptySpaceHelper.emptyHight(20),
//                                         Center(
//                                           child: RichText(
//                                             softWrap: true,
//                                             text: TextSpan(
//                                                 text: asProvider.getString(
//                                                     "Don't have an account?"),
//                                                 style: TextStyle(
//                                                   color: cc.greyHint,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                                 children: [
//                                                   TextSpan(
//                                                       text: '   ',
//                                                       style: TextStyle(
//                                                           color: cc.greyHint)),
//                                                   TextSpan(
//                                                       recognizer:
//                                                           TapGestureRecognizer()
//                                                             ..onTap = () {
//                                                               FocusScope.of(
//                                                                       context)
//                                                                   .unfocus();
//                                                               Provider.of<SignUpService>(
//                                                                       context,
//                                                                       listen:
//                                                                           false)
//                                                                   .setObscurePasswordOne(
//                                                                       true);
//                                                               Provider.of<SignUpService>(
//                                                                       context,
//                                                                       listen:
//                                                                           false)
//                                                                   .setObscurePasswordTwo(
//                                                                       true);
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .push(PageRouteBuilder(
//                                                                       pageBuilder: (context,
//                                                                           animation,
//                                                                           anotherAnimation) {
//                                                                 return SignUpView();
//                                                               },
//                                                                       // transitionDuration:
//                                                                       //     const Duration(milliseconds: 300),
//                                                                       transitionsBuilder: (context,
//                                                                           animation,
//                                                                           anotherAnimation,
//                                                                           child) {
//                                                                 animation = CurvedAnimation(
//                                                                     curve: Curves
//                                                                         .decelerate,
//                                                                     parent:
//                                                                         animation);
//                                                                 return Align(
//                                                                   child:
//                                                                       FadeTransition(
//                                                                     opacity:
//                                                                         animation,
//                                                                     // axisAlignment: 0.0,
//                                                                     child:
//                                                                         child,
//                                                                   ),
//                                                                 );
//                                                               }))
//                                                                   .then(
//                                                                       (value) {
//                                                                 if (value !=
//                                                                     null) {
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 }
//                                                               });
//                                                             },
//                                                       text: asProvider
//                                                           .getString('Sign up'),
//                                                       style: TextStyle(
//                                                           color: cc
//                                                               .secondaryColor)),
//                                                 ]),
//                                           ),
//                                         ),
//                                         EmptySpaceHelper.emptyHight(20),
//                                         const HorizontalOrDivider(),
//                                         EmptySpaceHelper.emptyHight(20),
//                                         Consumer<SocialSignInSignUpService>(
//                                             builder: (context, socialProvider,
//                                                 child) {
//                                           return SizedBox(
//                                             width: double.infinity,
//                                             height: 46,
//                                             child: OutlinedButton.icon(
//                                                 onPressed: () {
//                                                   FocusScope.of(context)
//                                                       .unfocus();
//                                                   if (socialProvider
//                                                       .loadingGoogleSignInSignUp) {
//                                                     return;
//                                                   }
//                                                   socialProvider
//                                                       .googleSignInSignUp(
//                                                           context,
//                                                           'Sign in failed');
//                                                 },
//                                                 icon: SvgPicture.asset(
//                                                     'assets/icons/google.svg'),
//                                                 label: socialProvider
//                                                         .loadingGoogleSignInSignUp
//                                                     ? FittedBox(
//                                                         child:
//                                                             CustomPreloader(),
//                                                       )
//                                                     : Text(asProvider.getString(
//                                                         'Sign in with Google'))),
//                                           );
//                                         }),
//                                         EmptySpaceHelper.emptyHight(10),
//                                         Consumer<SocialSignInSignUpService>(
//                                             builder: (context, socialProvider,
//                                                 child) {
//                                           return SizedBox(
//                                             width: double.infinity,
//                                             height: 46,
//                                             child: OutlinedButton.icon(
//                                                 onPressed: () {
//                                                   FocusScope.of(context)
//                                                       .unfocus();
//                                                   if (socialProvider
//                                                       .loadingFacebookSignInSignUp) {
//                                                     return;
//                                                   }
//                                                   socialProvider
//                                                       .facebookSignInSignUp(
//                                                           context,
//                                                           'Sign in failed');
//                                                 },
//                                                 icon: SvgPicture.asset(
//                                                     'assets/icons/facebook.svg'),
//                                                 label: socialProvider
//                                                         .loadingFacebookSignInSignUp
//                                                     ? FittedBox(
//                                                         child:
//                                                             CustomPreloader(),
//                                                       )
//                                                     : Text(asProvider.getString(
//                                                         'Sign in with Facebook'))),
//                                           );
//                                         }),
//                                         EmptySpaceHelper.emptyHight(20),
//                                       ]),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                     EmptySpaceHelper.emptyHight(screenHeight / 5),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:safecart/services/auth_service/sign_in_service.dart';
import 'package:safecart/services/auth_service/sign_up_service.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/services/auth_service/social_signin_signup_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/boxed_back_button.dart';
import 'package:safecart/widgets/common/custom_common_button.dart';
import 'package:safecart/widgets/common/field_title.dart';
import 'package:safecart/widgets/common/horizontal_or_divider.dart';
import 'package:safecart/widgets/common/web_view.dart';

class SignInView extends StatefulWidget {
  static const routeName = 'sign_in_view';
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedCountryCode = '+880'; // default selected
  bool _isPhoneLogin = true;

  trySignIn(BuildContext context) {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    final identifier = _isPhoneLogin 
      ? '$_selectedCountryCode${_phoneController.text.trim()}'
      : _emailController.text.trim();

    Provider.of<SignInService>(context, listen: false).signIn(
      context, 
      identifier, 
      _passwordController.text
    );
  }

  bool onceInit = false;

  initMailPass(BuildContext context) {
    if (!onceInit) {
      onceInit = true;
      final savedInfo = Provider.of<SaveSignInInfoService>(context, listen: false);
      
      // Check if saved info is phone or email
      final savedIdentifier = savedInfo.emailUsername ?? '';
      if (savedIdentifier.contains('@')) {
        _isPhoneLogin = false;
        _emailController.text = savedIdentifier;
      } else {
        _isPhoneLogin = true;
        // Extract country code if present
        if (savedIdentifier.startsWith('+')) {
          final plusIndex = savedIdentifier.indexOf('+');
          final spaceIndex = savedIdentifier.indexOf(' ');
          if (spaceIndex != -1) {
            _selectedCountryCode = savedIdentifier.substring(plusIndex, spaceIndex);
            _phoneController.text = savedIdentifier.substring(spaceIndex + 1);
          } else {
            // Handle case where there's no space after country code
            _phoneController.text = savedIdentifier;
          }
        } else {
          _phoneController.text = savedIdentifier;
        }
      }
      
      _passwordController.text = savedInfo.password ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    initMailPass(context);

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
                        asProvider.getString('Welcome Back'),
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
                                        // Toggle between phone and email
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ToggleButtons(
                                              isSelected: [_isPhoneLogin, !_isPhoneLogin],
                                              onPressed: (int index) {
                                                setState(() {
                                                  _isPhoneLogin = index == 0;
                                                });
                                              },
                                              borderRadius: BorderRadius.circular(8),
                                              selectedColor: Colors.white,
                                              fillColor: cc.primaryColor,
                                              color: cc.primaryColor,
                                              constraints: BoxConstraints(
                                                minHeight: 40,
                                                minWidth: screenWidth / 3,
                                              ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text(asProvider.getString('Phone')),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text(asProvider.getString('Email')),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        EmptySpaceHelper.emptyHight(15),
                                        
                                        // Phone or Email field based on selection
                                        if (_isPhoneLogin) ...[
                                          FieldTitle(asProvider.getString('Phone Number *')),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: DropdownButtonFormField<String>(
                                                  value: _selectedCountryCode,
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      setState(() {
                                                        _selectedCountryCode = newValue;
                                                      });
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  items: ['+1', '+880', '+855']
                                                      .map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                flex: 5,
                                                child: TextFormField(
                                                  controller: _phoneController,
                                                  keyboardType: TextInputType.phone,
                                                  decoration: InputDecoration(
                                                    hintText: asProvider.getString('Enter your phone number'),
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.trim().isEmpty) {
                                                      return asProvider.getString('Enter your phone number');
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          FieldTitle(asProvider.getString('Email')),
                                          TextFormField(
                                            controller: _emailController,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              hintText: asProvider.getString('Enter your email'),
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: SvgPicture.asset('assets/icons/email_prefix.svg'),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (!EmailValidator.validate(value ?? '')) {
                                                return asProvider.getString('Enter a valid email address');
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                        
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(asProvider.getString('Password')),
                                        Consumer<SignInService>(builder:
                                            (context, siProvider, child) {
                                          return TextFormField(
                                            controller: _passwordController,
                                            obscureText: siProvider.obscurePassword,
                                            decoration: InputDecoration(
                                              hintText: asProvider.getString('Enter your Password'),
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: SvgPicture.asset('assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  siProvider.setObscurePassword(null);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${siProvider.obscurePassword ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.trim().isEmpty ||
                                                  value.length < 6) {
                                                return asProvider.getString('Password must be more then 6 character');
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(context).unfocus();
                                              trySignIn(context);
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        Row(
                                          children: [
                                            Consumer<SignInService>(builder:
                                                (context, siProvider, child) {
                                              return Transform.scale(
                                                scale: 1.3,
                                                child: Checkbox(
                                                  value: siProvider.rememberPassword,
                                                  onChanged: (value) {
                                                    siProvider.setRememberPassword(value);
                                                  },
                                                ),
                                              );
                                            }),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: screenWidth / 4.5),
                                              child: FittedBox(
                                                child: Text(
                                                  asProvider.getString('Remember me'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: screenWidth / 3.2),
                                              child: FittedBox(
                                                child: TextButton(
                                                  onPressed: () {
                                                    FocusScope.of(context).unfocus();
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            pageBuilder: (context, animation, anotherAnimation) {
                                                              return ResetPasswordView();
                                                            },
                                                            reverseTransitionDuration: const Duration(microseconds: 10),
                                                            transitionsBuilder: (context, animation, anotherAnimation, child) {
                                                              animation = CurvedAnimation(
                                                                  curve: Curves.decelerate,
                                                                  parent: animation);
                                                              return Align(
                                                                child: FadeTransition(
                                                                  opacity: animation,
                                                                  child: child,
                                                                ),
                                                              );
                                                            }));
                                                  },
                                                  child: Text(
                                                    asProvider.getString('Forgot password?'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(color: cc.secondaryColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        Consumer<SignInService>(builder:
                                            (context, siProvider, child) {
                                          return CustomCommonButton(
                                              btText: asProvider.getString('Sign In'),
                                              isLoading: siProvider.loadingSignIn,
                                              onPressed: () {
                                                FocusScope.of(context).unfocus();
                                                trySignIn(context);
                                              });
                                        }),
                                        EmptySpaceHelper.emptyHight(20),
                                        Center(
                                          child: RichText(
                                            softWrap: true,
                                            text: TextSpan(
                                                text: asProvider.getString("Don't have an account?"),
                                                style: TextStyle(
                                                  color: cc.greyHint,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: '   ',
                                                      style: TextStyle(color: cc.greyHint)),
                                                  TextSpan(
                                                      recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          FocusScope.of(context).unfocus();
                                                          Provider.of<SignUpService>(context, listen: false)
                                                              .setObscurePasswordOne(true);
                                                          Provider.of<SignUpService>(context, listen: false)
                                                              .setObscurePasswordTwo(true);
                                                          Navigator.of(context)
                                                              .push(PageRouteBuilder(
                                                                  pageBuilder: (context, animation, anotherAnimation) {
                                                                    return SignUpView();
                                                                  },
                                                                  transitionsBuilder: (context, animation, anotherAnimation, child) {
                                                                    animation = CurvedAnimation(
                                                                        curve: Curves.decelerate,
                                                                        parent: animation);
                                                                    return Align(
                                                                      child: FadeTransition(
                                                                        opacity: animation,
                                                                        child: child,
                                                                      ),
                                                                    );
                                                                  }))
                                                              .then((value) {
                                                            if (value != null) {
                                                              Navigator.pop(context);
                                                            }
                                                          });
                                                        },
                                                      text: asProvider.getString('Sign up'),
                                                      style: TextStyle(color: cc.secondaryColor)),
                                                ]),
                                          ),
                                        ),
                                        EmptySpaceHelper.emptyHight(20),
                                        const HorizontalOrDivider(),
                                        EmptySpaceHelper.emptyHight(20),
                                        Consumer<SocialSignInSignUpService>(
                                            builder: (context, socialProvider, child) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 46,
                                            child: OutlinedButton.icon(
                                                onPressed: () {
                                                  FocusScope.of(context).unfocus();
                                                  if (socialProvider.loadingGoogleSignInSignUp) {
                                                    return;
                                                  }
                                                  socialProvider.googleSignInSignUp(
                                                      context, 'Sign in failed');
                                                },
                                                icon: SvgPicture.asset('assets/icons/google.svg'),
                                                label: socialProvider.loadingGoogleSignInSignUp
                                                    ? FittedBox(child: CustomPreloader())
                                                    : Text(asProvider.getString('Sign in with Google'))),
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        Consumer<SocialSignInSignUpService>(
                                            builder: (context, socialProvider, child) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 46,
                                            child: OutlinedButton.icon(
                                                onPressed: () {
                                                  FocusScope.of(context).unfocus();
                                                  if (socialProvider.loadingFacebookSignInSignUp) {
                                                    return;
                                                  }
                                                  socialProvider.facebookSignInSignUp(
                                                      context, 'Sign in failed');
                                                },
                                                icon: SvgPicture.asset('assets/icons/facebook.svg'),
                                                label: socialProvider.loadingFacebookSignInSignUp
                                                    ? FittedBox(child: CustomPreloader())
                                                    : Text(asProvider.getString('Sign in with Facebook'))),
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(20),
                                      ]),
                                )),
                          ],
                        ),
                      ),
                    ),
                    EmptySpaceHelper.emptyHight(screenHeight / 5),
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