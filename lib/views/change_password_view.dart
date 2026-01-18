import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/change_password_service.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';

class ChangePasswordView extends StatefulWidget {
  static const routeName = 'change_name_view';
  ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  // Visibility states
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  tryChangePassword(BuildContext context) {
    FocusScope.of(context).unfocus();
    bool valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    Provider.of<ChangePasswordService>(context, listen: false)
        .changePassword(context, _currentPassword.text, _newPassword.text);
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
          alignment: Alignment.topCenter,
          child: const Center(),
        ),
        CustomScrollView(slivers: [
          SliverAppBar(
            elevation: 1,
            leadingWidth: 60,
            toolbarHeight: 60,
            foregroundColor: cc.greyHint,
            backgroundColor: Colors.transparent,
            expandedHeight: screenHeight / 3.7,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: screenHeight / 3.7,
                width: double.infinity,
                color: cc.primaryColor,
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    asProvider.getString('Change Password'),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldTitle(asProvider.getString('Current password')),
                          TextFormField(
                            controller: _currentPassword,
                            obscureText: _obscureCurrent,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: asProvider
                                    .getString('Enter your current password'),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureCurrent
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => setState(() =>
                                      _obscureCurrent = !_obscureCurrent),
                                )),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return asProvider.getString(
                                    'Please provide current password');
                              }
                              return null;
                            },
                          ),
                          FieldTitle(asProvider.getString('New password')),
                          TextFormField(
                            controller: _newPassword,
                            obscureText: _obscureNew,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: asProvider
                                    .getString('Enter new password'),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureNew
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => setState(
                                      () => _obscureNew = !_obscureNew),
                                )),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return asProvider.getString(
                                    'Password must be at least 6 character');
                              }
                              return null;
                            },
                          ),
                          FieldTitle(
                              asProvider.getString('Confirm new password')),
                          TextFormField(
                            controller: _confirmPassword,
                            obscureText: _obscureConfirm,
                            decoration: InputDecoration(
                                hintText: asProvider
                                    .getString('Re-enter new password'),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => setState(() =>
                                      _obscureConfirm = !_obscureConfirm),
                                )),
                            validator: (value) {
                              if (_newPassword.text != value) {
                                return asProvider
                                    .getString("Password didn't match");
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) =>
                                tryChangePassword(context),
                          ),
                          EmptySpaceHelper.emptyHight(30),
                          Consumer<ChangePasswordService>(
                              builder: (context, cpProvider, child) {
                            return CustomCommonButton(
                              btText: asProvider.getString('Change Password'),
                              isLoading: cpProvider.loadingChangePassword,
                              onPressed: () {
                                tryChangePassword(context);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ],
    ));
  }
}