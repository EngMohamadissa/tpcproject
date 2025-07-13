import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp/core/util/styles.dart';
import 'package:tcp/feutaure/home/presentation/view/widget/build_property_item.dart';

Widget buildPropertiesContainer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          'ماذا تريد؟',
          style: Styles.textStyle28,
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
          buildPropertyItem(Icons.scale, 'الكمية', '150 كجم'),
          buildPropertyItem(Icons.attach_money, 'السعر', '25\$'),
          buildPropertyItem(Icons.grade, 'الجودة', 'ممتازة'),
          buildPropertyItem(Icons.date_range, 'الإنتاج', '2023-10-15'),
          buildPropertyItem(Icons.event_busy, 'الانتهاء', '2024-10-15'),
          buildPropertyItem(Icons.place, 'المكان', 'المستودع أ'),
          buildPropertyItem(Icons.trending_up, 'المعدل', '5 كجم/يوم'),
          buildPropertyItem(Icons.thermostat, 'الحرارة', '25°C'),
        ],
      ),
    ],
  );
}
