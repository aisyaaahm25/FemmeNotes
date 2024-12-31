
import 'package:flutter/material.dart';
import 'package:femme_notes_app/pages/providers/auth_provider.dart';
import 'package:femme_notes_app/theme.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    await Provider.of<AuthProvider>(context, listen: false).fetchUserProfile();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final name = authProvider.name ?? '';
    final email = authProvider.email ?? '';

    Widget header() {
      return AppBar(
        backgroundColor: background01,
        title: Text(
          "Profile",
          style: tertiaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semibold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 87),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/image-profile.png",
                    width: 145,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isLoading ? 'Loading . . .' : name,
                  style: tertiaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLoading ? '' : email,
                  style: tertiaryTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget menuItem(String text) {
      return Container(
        margin: const EdgeInsets.only(
          top: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: tertiaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
            ),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          decoration: BoxDecoration(
            color: background01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultMargin),
              Text(
                "Account",
                style: secondaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semibold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: menuItem(
                  "Edit Profile",
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await context.read<AuthProvider>().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/sign-in',
                    (route) => false,
                  );
                },
                child: menuItem(
                  "Log Out",
                ),
              ),
              menuItem(
                "Help",
              ),
              SizedBox(
                height: defaultMargin,
              ),
              Text(
                "General",
                style: secondaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semibold,
                ),
              ),
              menuItem(
                "Privacy & Policy",
              ),
              menuItem(
                "Term of Service",
              ),
              menuItem(
                "Rate App",
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
