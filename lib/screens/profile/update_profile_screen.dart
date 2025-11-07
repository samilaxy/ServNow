import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../utilities/constants.dart';
import '../../controllers/profile_proviver.dart';
import '../../models/user_model.dart';
import '../components/image_with_placeholder.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Pre-fill profile if information is available
    fullNameController.text = profileProvider.name;
    emailController.text = profileProvider.email;
    phoneController.text = profileProvider.contact;
    bioController.text = profileProvider.bio;
    Uint8List? image = profileProvider.image;
    String? imgUrl = profileProvider.imageUrl;
    String? role = profileProvider.role;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(tProfileImage))),
                  ),
                  image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(image),
                        )
                      : SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ImageWithPlaceholder(
                                  imageUrl: profileProvider.imageUrl,
                                  placeholderUrl: tProfileImage)),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: mainColor),
                        child: IconButton(
                          onPressed: () {
                            profileProvider.selectImg();
                          },
                          icon: const Icon(
                            LineAwesomeIcons.camera_solid,
                            color: Colors.white,
                            size: 20,
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: fullNameController,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Full Name"),
                          prefixIcon: const Icon(
                            LineAwesomeIcons.user,
                            color: Colors.grey,
                          )),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Email"),
                          prefixIcon: const Icon(LineAwesomeIcons.envelope_solid)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Phone"),
                          prefixIcon: const Icon(LineAwesomeIcons.phone_solid)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: bioController,
                      maxLines: 5, // Declare a TextEditingController
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        label: const Text("Bio"),
                        prefixIcon: const Icon(LineAwesomeIcons.info_circle_solid),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final fullName = fullNameController.text.trim();
                          final email = emailController.text.trim();
                          final phone = phoneController.text.trim();
                          final bio = bioController.text.trim();

                          //   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          final userModel = UserModel(
                            fullName: fullName,
                            email: email,
                            phone: phone,
                            bio: bio,
                            img: imgUrl,
                            isUser: true, 
                            role: role,
                          );
                          profileProvider.isLoading
                              ? null
                              : profileProvider.createUser(userModel, context);
                          //  Navigator.pushNamed(context, 'profile');
                        },
                        //  },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: profileProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.black26),
                              )
                            : const Text("Update",
                                style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: "Joined",
                            style: TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "  May 23",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text("Delete"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, 'profile'),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Edit Profile",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
