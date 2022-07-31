import 'dart:io';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterAccountPicture extends StatefulWidget {
  const RegisterAccountPicture({Key? key}) : super(key: key);

  @override
  State<RegisterAccountPicture> createState() => _RegisterAccountPictureState();
}

class _RegisterAccountPictureState extends State<RegisterAccountPicture> {
  final _picker = ImagePicker();
  final _profile = Get.put(ProfileController());

  String _img1Path = "";
  String _img1Name = "";

  Future<void> onSelectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  Future<void> onRegister() async {
    if (_img1Path.isEmpty || _img1Name.isEmpty) return onSelectImage();

    _profile.createProfileData.addAll(
      {
        "img": {
          "name": _img1Name,
          "path": _img1Path,
        },
      },
    );

    await _profile.createProfile("customer");
  }

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "Profile Avatar",
      style: GoogleFonts.chivo(
        fontWeight: FontWeight.bold,
        color: kLight,
        fontSize: 15,
      ),
    );
    final _subTitle = Text(
      "Upload your best photo",
      style: GoogleFonts.roboto(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        color: kLight,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kPrimary,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_title, _subTitle],
          ),
          backgroundColor: kPrimary,
          elevation: 0,
          leading: const SizedBox(),
          leadingWidth: 0.0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () => Get.back(),
                splashRadius: 20.0,
                icon: const Icon(
                  AntDesign.close,
                  color: kLight,
                ),
              ),
            )
          ],
        ),
        body: Container(
          margin: kDefaultBodyPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(300)),
                    child: _img1Path == ""
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async => await onSelectImage(),
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [10, 10],
                              color: kLight,
                              strokeWidth: 1.5,
                              child: Stack(
                                children: const [
                                  SizedBox(
                                    height: 280,
                                    width: 280,
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        AntDesign.plus,
                                        color: kLight,
                                        size: 34.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => onSelectImage(),
                            child: Image.file(
                              File(_img1Path),
                              height: 280,
                              width: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: TextButton(
                  onPressed: () => onRegister(),
                  style: TextButton.styleFrom(
                    //primary: kFadeWhite,
                    backgroundColor: kSecondary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: kDefaultRadius,
                    ),
                  ),
                  child: Text(
                    "CREATE MY ACCOUNT",
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: kLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
