import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/profile_info_service.dart';
import '../../utils/responsive.dart';
import '../../views/edit_profile_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class ProfileInfo extends StatelessWidget {
  bool editing;
  ProfileInfo({this.editing = false, super.key});

  Future<void> imageSelector(BuildContext context) async {
    try {
      // Request photo library permission
      var status = await Permission.photos.status;
      print('Initial photo permission status: $status');
      if (!status.isGranted) {
        status = await Permission.photos.request();
        print('Photo permission request result: $status');
      }
      if (!status.isGranted) {
        print('Photo library permission denied');
        showToast(
          asProvider.getString('Photo library permission denied'),
          cc.red,
        );
        // Open app settings for user to grant permission
        await openAppSettings();
        return;
      }

      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      if (file != null && file.files.first.path != null) {
        String filePath = file.files.first.path!;
        print('Selected file path: $filePath');
        File imageFile = File(filePath);
        if (await imageFile.exists()) {
          print('File exists at path: $filePath');
          print('File size: ${await imageFile.length()} bytes');
          Provider.of<ProfileInfoService>(context, listen: false)
              .setSelectedImage(imageFile);
        } else {
          print('File does not exist at path: $filePath');
          showToast(
            asProvider.getString('Selected file is invalid'),
            cc.red,
          );
        }
      } else {
        print('No file selected or path is null');
        showToast(
          asProvider.getString('No file selected'),
          cc.red,
        );
      }
    } catch (error) {
      print('Error selecting image: $error');
      showToast(
        asProvider.getString('Error selecting image: $error'),
        cc.red,
      );
    }
  }
  // Future<void> imageSelector(
  //   BuildContext context,
  // ) async {
  //   try {
  //     FilePickerResult? file = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowMultiple: false,
  //       allowedExtensions: ['jpg', 'png', 'jpeg'],
  //     );
  //     if (file?.files.first.path != null) {
  //       Provider.of<ProfileInfoService>(context, listen: false)
  //           .setSelectedImage(File(file?.files.first.path ?? ''));
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('Dp clicked');
                        if (!editing) {
                          // final pProvider =
                          //     Provider.of<ProfileInfoService>(context, listen: false);
                          // if (pProvider.profileInfo?.userDetails.userCountry?.name !=
                          //     null) {
                          //   Provider.of<CountryStateService>(context, listen: false)
                          //       .fetchAllStates(
                          //           context,
                          //           Provider.of<CountryStateService>(context,
                          //                   listen: false)
                          //               .getCountryId(pProvider.profileInfo
                          //                   ?.userDetails.userCountry!.name));
                          // }
                          Navigator.of(context)
                              .pushNamed(EditProfileView.routeName);
                          return;
                        }
                        imageSelector(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Consumer<ProfileInfoService>(
                            builder: (context, pProvider, child) {
                          return SizedBox(
                            width: screenWidth / 3.6,
                            height: screenWidth / 3.6,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: pProvider.selectedImage != null
                                    ? Image.file(
                                        pProvider.selectedImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: pProvider.profileInfo!
                                                .userDetails.profileImageUrl ??
                                            '',
                                        placeholder: (context, url) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: cc.secondaryColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              pProvider
                                                  .profileInfo!.userDetails.name
                                                  .substring(0, 2)
                                                  .toUpperCase()
                                                  .trim(),
                                              style: TextStyle(
                                                  color: cc.pureWhite,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 45),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: cc.secondaryColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              pProvider
                                                  .profileInfo!.userDetails.name
                                                  .substring(0, 2)
                                                  .toUpperCase()
                                                  .trim(),
                                              style: TextStyle(
                                                  color: cc.pureWhite,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 45),
                                            ),
                                          );
                                        },
                                      )),
                          );
                        }),
                      ),
                    ),
                    if (editing)
                      GestureDetector(
                        onTap: () {
                          imageSelector(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SvgPicture.asset(
                            'assets/icons/camera.svg',
                            height: 35,
                          ),
                        ),
                      ),
                  ],
                ),
                Consumer<ProfileInfoService>(
                    builder: (context, pProvider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EmptySpaceHelper.emptyHight(10),
                      Text(
                        pProvider.profileInfo!.userDetails.name.capitalize(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cc.pureWhite,
                            ),
                      ),
                      EmptySpaceHelper.emptyHight(4),
                      Text(
                        pProvider.profileInfo!.userDetails.email,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: cc.pureWhite,
                            ),
                      ),
                      if (!editing)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditProfileView.routeName);
                            return;
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            color: cc.pureWhite,
                          ),
                          label: Text(
                            asProvider.getString('Edit Profile'),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: cc.pureWhite,
                                ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: cc.pureWhite,
                            padding: EdgeInsets.zero,
                            surfaceTintColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            elevation: 0,
                          ),
                        )
                    ],
                  );
                })
              ],
            ),
          ),
        );
      }),
    );
  }
}
