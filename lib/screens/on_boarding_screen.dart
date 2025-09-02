import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp/constants/my_app_colors.dart';
import 'package:tcp/constants/on_boarding.dart';
import 'package:tcp/screens/register_screen.dart';
import 'package:tcp/widgets/auth_widget/primary_button.dart';
import 'package:tcp/widgets/onboarding_widgets/on_boarding_card.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.kOnBoardingColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Container(
            height: 10.h,
            width: 10.h,
            margin: EdgeInsets.all(25.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyAppColors.kPrimary,
            ),
          ),
          SizedBox(height: 14.h),

          /// قسم العروض الرئيسية
          Expanded(
            flex: 5,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: onBoardinglist.length,
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return OnBoardingCard(
                  onBoardingModel: onBoardinglist[index],
                );
              },
            ),
          ),

          SizedBox(height: 36.h),

          /// مؤشر النقاط
          Center(
            child: DotsIndicator(
              dotsCount: onBoardinglist.length,
              position: _currentIndex,
              decorator: DotsDecorator(
                color: MyAppColors.kPrimary,
                size: Size.square(10.0.sp),
                activeSize: Size(20.0.sp, 8.0.sp),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                activeColor: MyAppColors.kPrimary,
              ),
            ),
          ),

          SizedBox(height: 37.h),

          /// عرض عنوان ووصف الصفحة الحالية
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  onBoardinglist[_currentIndex].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    onBoardinglist[_currentIndex].description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // /// زر الانتقال بين الصفحات
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 25.w, right: 23.w, bottom: 30.h),
              child: PrimaryButton(
                elevation: 0,
                onTap: () {
                  setState(() {
                    if (_currentIndex == onBoardinglist.length - 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    }
                  });
                },
                bgColor: MyAppColors.kPrimary,
                borderRadius: 20.r,
                height: 40.h,
                width: 280.w,
                textColor: MyAppColors.kWhite,
                child: Text(
                  _currentIndex == onBoardinglist.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: MyAppColors.kWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
