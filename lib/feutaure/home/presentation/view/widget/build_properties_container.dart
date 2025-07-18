import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp/core/util/styles.dart';
import 'package:tcp/feutaure/ProductSaleReports/presentation/view/ReportsControlScreen.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/view/get_production_setting_by_month_page.dart';
import 'package:tcp/feutaure/allUsers/presentation/user_view.dart';
import 'package:tcp/feutaure/conversions/presentation/view/conversions_list_screen.dart';
import 'package:tcp/feutaure/home/presentation/view/widget/build_property_item.dart';
import 'package:tcp/feutaure/profit-loss-report/presentation/view/profit_loss_view.dart';

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
          buildPropertyItem(Icons.scale, 'Conversions', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConversionsListScreen()),
            );
          }),
          buildPropertyItem(Icons.person, 'All Users', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsersListScreen(),
              ),
            );
          }),
          buildPropertyItem(Icons.date_range, 'Production Settings', '2023-10',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductionSettingsOverviewScreen()),
            );
          }),
          buildPropertyItem(Icons.grade, 'Profit Loss ', 'Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfitLossReportScreen()),
            );
          }),
          buildPropertyItem(Icons.event_busy, 'Product Sale', 'Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsControlScreen()),
            );
          }),
          buildPropertyItem(Icons.place, 'المكان', 'المستودع أ', () {}),
          buildPropertyItem(Icons.trending_up, 'المعدل', '5 كجم/يوم', () {}),
          buildPropertyItem(Icons.thermostat, 'الحرارة', '25°C', () {}),
        ],
      ),
    ],
  );
}
