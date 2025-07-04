import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:safecart/services/auth_service/sign_in_service.dart';

import '../../services/auth_service/sign_up_service.dart';
import '../../utils/custom_preloader.dart';
import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/auth_service/social_signin_signup_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';
import '../widgets/common/horizontal_or_divider.dart';
import '../widgets/common/web_view.dart';

class SignUpView extends StatefulWidget {
  static const routeName = 'sign_up_view';
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();

  String _selectedCountryCode = '+880'; // default selected

  trySignUp(BuildContext context) {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    final suProvider = Provider.of<SignUpService>(context, listen: false);

    if (suProvider.acceptTPP != true) {
      showToast(
          asProvider.getString('You have to agree our terms and conditions'),
          cc.red);
      return;
    }
      final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
    suProvider.signUp(
      context,
      _nameController.text,
      _emailController.text,
      _userNameController.text,
      _newPassController.text,
      fullPhoneNumber,
      // _phoneController.text,
    );
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
                    // padding: EdgeInsets.only(top: screenHeight / 7),
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        asProvider.getString('Welcome'),
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
                            // AuthAppBar(),
                            Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FieldTitle(asProvider
                                                .getString('Phone Number *')),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: _selectedCountryCode,
                                                    onChanged:
                                                        (String? newValue) {
                                                      if (newValue != null) {
                                                        setState(() {
                                                          _selectedCountryCode =
                                                              newValue;
                                                        });
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    items: [
                                                      '+1',
                                                      '+880',
                                                      '+855'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
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
                                                    controller:
                                                        _phoneController,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          asProvider.getString(
                                                              'Enter your phone number'),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return asProvider.getString(
                                                            'Enter your phone number');
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        FieldTitle(
                                            asProvider.getString('Name')),
                                        TextFormField(
                                          controller: _nameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              hintText: asProvider
                                                  .getString('Enter your name'),
                                              prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                      'assets/icons/profile_prefix.svg'))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.length < 3) {
                                              return asProvider.getString(
                                                  'Enter a valid name');
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(
                                            asProvider.getString('Username')),
                                        TextFormField(
                                          controller: _userNameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: asProvider.getString(
                                                'Enter your username'),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  'assets/icons/profile_prefix.svg'),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.length < 3) {
                                              return asProvider.getString(
                                                  'Enter a valid username');
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(
                                            asProvider.getString('Email')),
                                        TextFormField(
                                          controller: _emailController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: asProvider
                                                .getString('Enter your email'),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  'assets/icons/email_prefix.svg'),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (!EmailValidator.validate(
                                                value ?? '')) {
                                              return asProvider.getString(
                                                  'Enter a valid email address');
                                            }
                                            return null;
                                          },
                                        ),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(
                                            asProvider.getString('Password')),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return TextFormField(
                                            controller: _newPassController,
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText:
                                                suProvider.obscurePasswordOne,
                                            decoration: InputDecoration(
                                              hintText: asProvider.getString(
                                                  'Enter your Password'),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SvgPicture.asset(
                                                    'assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  suProvider
                                                      .setObscurePasswordOne(
                                                          null);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${suProvider.obscurePasswordOne ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                               if (value == null || value.trim().isEmpty) {
                                                return 'Password cannot be empty';
                                              }
                                              if (value.length < 8) {
                                                return 'Password must be at least 8 characters';
                                              }
                                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                                return 'Password must contain at least 1 uppercase letter';
                                              }
                                              if (!value.contains(RegExp(r'[a-z]'))) {
                                                return 'Password must contain at least 1 lowercase letter';
                                              }
                                              if (!value.contains(RegExp(r'[0-9]'))) {
                                                return 'Password must contain at least 1 number';
                                              }
                                              if (value.contains(' ')) {
                                                return 'Password cannot contain spaces';
                                              }
                                              return null;
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        FieldTitle(asProvider
                                            .getString('Confirm Password')),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return TextFormField(
                                            obscureText:
                                                suProvider.obscurePasswordTwo,
                                            decoration: InputDecoration(
                                              hintText: asProvider.getString(
                                                  'Re-enter your Password'),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SvgPicture.asset(
                                                    'assets/icons/pass_prefix.svg'),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  suProvider
                                                      .setObscurePasswordTwo(
                                                          null);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/${suProvider.obscurePasswordTwo ? 'obscure_on' : 'obscure_off'}.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_newPassController.text !=
                                                  value) {
                                                return asProvider.getString(
                                                    "Password didn't match");
                                              }
                                              return null;
                                            },
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(15),
                                        Row(
                                          children: [
                                            Consumer<SignUpService>(builder:
                                                (context, suProvider, child) {
                                              return Transform.scale(
                                                scale: 1.3,
                                                child: Checkbox(
                                                  value: suProvider.acceptTPP,
                                                  onChanged: (value) {
                                                    suProvider
                                                        .setAcceptTPP(value);
                                                  },
                                                ),
                                              );
                                            }),
                                            SizedBox(
                                              width: screenWidth - 150,
                                              child: RichText(
                                                softWrap: true,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                    text:
                                                        '${asProvider.getString('By creating an account,you agree to the')} ',
                                                    style: TextStyle(
                                                      color: cc.greyHint,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          WebViewScreen
                                                                              .routeName,
                                                                          arguments: [
                                                                        asProvider
                                                                            .getString('Terms and Conditions'),
                                                                        '$baseApi/terms-and-condition-page'
                                                                      ]);
                                                                },
                                                          text: asProvider
                                                              .getString(
                                                                  'terms of service and Conditions'),
                                                          style: TextStyle(
                                                              color: cc
                                                                  .secondaryColor)),
                                                      TextSpan(
                                                          text:
                                                              ', ${asProvider.getString('and')} ',
                                                          style: TextStyle(
                                                              color:
                                                                  cc.greyHint)),
                                                      TextSpan(
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          WebViewScreen
                                                                              .routeName,
                                                                          arguments: [
                                                                        asProvider
                                                                            .getString('Privacy Policy'),
                                                                        '$baseApi/privacy-policy-page'
                                                                      ]);
                                                                },
                                                          text: asProvider
                                                              .getString(
                                                                  'privacy policy.'),
                                                          style: TextStyle(
                                                              color: cc
                                                                  .secondaryColor)),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        EmptySpaceHelper.emptyHight(15),
                                        Consumer<SignUpService>(builder:
                                            (context, suProvider, child) {
                                          return CustomCommonButton(
                                              btText: asProvider
                                                  .getString('Sign Up'),
                                              isLoading:
                                                  suProvider.loadingSignUp,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                trySignUp(context);
                                              });
                                        }),
                                        EmptySpaceHelper.emptyHight(20),
                                        Center(
                                          child: RichText(
                                            softWrap: true,
                                            text: TextSpan(
                                                text: asProvider.getString(
                                                    'Already have an account?'),
                                                style: TextStyle(
                                                  color: cc.greyHint,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: '   ',
                                                      style: TextStyle(
                                                          color: cc.greyHint)),
                                                  TextSpan(
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              Provider.of<SignInService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setObscurePassword(
                                                                      true);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                      text: asProvider
                                                          .getString('Sign In'),
                                                      style: TextStyle(
                                                          color: cc
                                                              .secondaryColor)),
                                                ]),
                                          ),
                                        ),
                                        EmptySpaceHelper.emptyHight(20),
                                        const HorizontalOrDivider(),
                                        EmptySpaceHelper.emptyHight(20),
                                        Consumer<SocialSignInSignUpService>(
                                            builder: (context, socialProvider,
                                                child) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 46,
                                            child: OutlinedButton.icon(
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (socialProvider
                                                      .loadingGoogleSignInSignUp) {
                                                    return;
                                                  }
                                                  socialProvider
                                                      .googleSignInSignUp(
                                                          context,
                                                          'Sign up failed');
                                                },
                                                icon: SvgPicture.asset(
                                                    'assets/icons/google.svg'),
                                                label: socialProvider
                                                        .loadingGoogleSignInSignUp
                                                    ? FittedBox(
                                                        child:
                                                            CustomPreloader(),
                                                      )
                                                    : Text(asProvider.getString(
                                                        'Sign up with Google'))),
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(10),
                                        Consumer<SocialSignInSignUpService>(
                                            builder: (context, socialProvider,
                                                child) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 46,
                                            child: OutlinedButton.icon(
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (socialProvider
                                                      .loadingFacebookSignInSignUp) {
                                                    return;
                                                  }
                                                  socialProvider
                                                      .facebookSignInSignUp(
                                                          context,
                                                          'Sign up failed');
                                                },
                                                icon: SvgPicture.asset(
                                                    'assets/icons/facebook.svg'),
                                                label: socialProvider
                                                        .loadingFacebookSignInSignUp
                                                    ? FittedBox(
                                                        child:
                                                            CustomPreloader(),
                                                      )
                                                    : Text(asProvider.getString(
                                                        'Sign up with Facebook'))),
                                          );
                                        }),
                                        EmptySpaceHelper.emptyHight(30),
                                      ]),
                                ))
                          ],
                        ),
                      ),
                    ),
                    EmptySpaceHelper.emptyHight(50),
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
