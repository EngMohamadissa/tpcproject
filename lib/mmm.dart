import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcp/constants/my_app_colors.dart';
import 'package:tcp/view_models/auth_cubit/auth_cubit.dart';
import 'package:tcp/view_models/auth_cubit/auth_state.dart';
import 'package:tcp/widgets/auth_widget/password_text_field.dart';
import 'package:tcp/widgets/auth_widget/primary_button.dart';
import 'package:tcp/widgets/auth_widget/primary_textform_field.dart';

class MMMLoginScreen extends StatelessWidget {
  MMMLoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Login',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: MyAppColors.kGrayscaleDark100,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          final authCubit = context.read<AuthCubit>();

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      'Welcome back',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: MyAppColors.kGrayscaleDark100,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Please sign in to continue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: MyAppColors.kGrayscale40,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Email
                    Text(
                      'Email',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: MyAppColors.kGrayscaleDark100,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    PrimaryTextformField(
                      save: (email) {
                        authCubit.email.text = email ?? '';
                      },
                      validate: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'email required';
                        }
                        final atIndex = value.indexOf('@');
                        if (atIndex <= 0) return 'invalid email';
                        final local = value.substring(0, atIndex);
                        if (int.tryParse(local) != null ||
                            double.tryParse(local) != null ||
                            local.length < 3) {
                          return 'invalid email';
                        }
                        return null;
                      },
                      TextController: authCubit.email,
                      label: 'email',
                      suffixIcon: const Icon(Icons.email_outlined),
                    ),

                    SizedBox(height: 16.h),

                    // Password
                    Text(
                      'Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: MyAppColors.kGrayscaleDark100,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    PasswordTextField(
                      save: (pass) {
                        authCubit.password.text = pass ?? '';
                      },
                      validate: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'password missing';
                        }
                        if (value.trim().length < 8) {
                          return 'password too short';
                        }
                        return null;
                      },
                      label: 'password',
                      TextController: authCubit.password,
                    ),

                    SizedBox(height: 24.h),

                    Center(
                      child: PrimaryButton(
                        elevation: 0,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            authCubit.logIn();
                          }
                        },
                        bgColor: MyAppColors.kPrimary,
                        borderRadius: 20.r,
                        height: 40.h,
                        width: 280.w,
                        textColor: MyAppColors.kWhite,
                        fontSize: 16.sp,
                        child: (state is Loading)
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: MyAppColors.kWhite,
                                  fontSize: 16.sp,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
