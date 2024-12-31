import 'package:flutter/material.dart';
import 'package:femme_notes_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:femme_notes_app/pages/providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    nameController.text = authProvider.name ?? '';
    emailController.text = authProvider.email ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    if (name.isNotEmpty && email.isNotEmpty) {
      try {
        await authProvider.updateUser(name, email);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Email cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: secondaryColor,
        ),
        actions: [
          IconButton(
            onPressed: saveProfile,
            icon: const Icon(Icons.check),
            color: secondaryColor,
          )
        ],
        backgroundColor: background01,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: secondaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semibold,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      );
    }

    Widget nameInput() {
      return Container(
        margin: const EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Full Name",
              style: secondaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Chris",
                hintStyle: tertiaryTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(
          top: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email Address",
              style: secondaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "chrisevan@gmail.com",
                hintStyle: primaryTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 145,
              height: 145,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/image-profile.png",
                  ),
                ),
              ),
            ),
            nameInput(),
            emailInput(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: background01,
      appBar: header(),
      body: content(),
      resizeToAvoidBottomInset: false,
    );
  }
}
