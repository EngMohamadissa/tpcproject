import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp/core/util/styles.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/view/get_production_setting_by_month_page.dart';
import 'package:tcp/feutaure/allUsers/presentation/user_view.dart';
import 'package:tcp/feutaure/home/presentation/view/widget/build_property_item.dart';

Widget buildPropertiesContainer(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          'What You Want?🤔',
          style: Styles.textStyle24,
        ),
      ),
      SizedBox(height: 16.h),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4, // 4 عناصر في السطر
        childAspectRatio: 0.95, // تعديل النسبة لتناسب المحتوى
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          buildPropertyItem(Icons.scale, 'الكمية', '150 كجم', () {}),
          buildPropertyItem(Icons.person, 'All Users', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsersListScreen(),
              ),
            );
          }),
          buildPropertyItem(Icons.grade, 'الجودة', 'ممتازة', () {}),
          buildPropertyItem(Icons.date_range, 'Production Settings', '2023-10',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductionSettingsOverviewScreen()),
            );
          }),
          buildPropertyItem(Icons.event_busy, 'الانتهاء', '2024-10-15', () {}),
          buildPropertyItem(Icons.place, 'المكان', 'المستودع أ', () {}),
          buildPropertyItem(Icons.trending_up, 'المعدل', '5 كجم/يوم', () {}),
          buildPropertyItem(Icons.thermostat, 'الحرارة', '25°C', () {}),
        ],
      ),
    ],
  );
}
