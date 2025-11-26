import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_managment/providers/auth_provider.dart';
import 'package:task_managment/providers/theme_provider.dart';
import '../widgets/app_bottom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  final _passwordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).value;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _imagePath = user?.image;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } else if (status.isDenied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission is required to pick an image'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.lexendDeca(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.dividerColor.withOpacity(0.4),
                            ),
                            image: DecorationImage(
                              image:
                                  _imagePath != null &&
                                      File(_imagePath!).existsSync()
                                  ? FileImage(File(_imagePath!))
                                  : (user?.image != null &&
                                                user!.image.isNotEmpty &&
                                                !user.image.startsWith('http')
                                            ? FileImage(File(user.image))
                                            : const AssetImage(
                                                'assets/profile/default_profile.png',
                                              ))
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Personal Information',
                  style: GoogleFonts.lexendDeca(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 32),
                Text(
                  'Account Security',
                  style: GoogleFonts.lexendDeca(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Min 6 chars';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Appearance',
                  style: GoogleFonts.lexendDeca(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dark Mode',
                            style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Switch between light and dark themes',
                            style: GoogleFonts.lexendDeca(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .setMode(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Changes',
                        style: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Current Password (Required)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        validator: (value) => value?.isEmpty == true
                            ? 'Required to save changes'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                authState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppBottomButton(
                        text: 'Save Changes',
                        hasArrow: false,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final isVerified = await ref
                                .read(authProvider.notifier)
                                .verifyPassword(
                                  _currentPasswordController.text,
                                );

                            if (!mounted) return;

                            if (!isVerified) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Incorrect current password'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            ref
                                .read(authProvider.notifier)
                                .updateProfile(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  username: _usernameController.text,
                                  password: _passwordController.text.isNotEmpty
                                      ? _passwordController.text
                                      : null,
                                  imagePath: _imagePath,
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            _currentPasswordController.clear();
                            _passwordController.clear();
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
