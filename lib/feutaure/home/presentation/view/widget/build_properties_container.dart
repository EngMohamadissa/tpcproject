import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp/core/util/styles.dart';
import 'package:tcp/feutaure/ProductSaleReports/presentation/view/ReportsControlScreen.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/view/get_production_setting_by_month_page.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/view/product_setting_controller_view.dart';
import 'package:tcp/feutaure/allUsers/presentation/user_view.dart';
import 'package:tcp/feutaure/conversions/presentation/view/conversions_list_screen.dart';
import 'package:tcp/feutaure/damagedmaterial/presentation/view/damaged_materials_screen.dart';
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
        crossAxisCount: 4, // 4 items per row
        childAspectRatio: 0.95, // Adjust ratio to fit content
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          buildPropertyItem(Icons.swap_horiz, 'Conversions', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConversionsListScreen()),
            );
          }),
          buildPropertyItem(Icons.people, 'All Users', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsersListScreen(),
              ),
            );
          }),
          buildPropertyItem(Icons.settings, 'Production Settings', '2023-10',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductSettingControllerView()),
            );
          }),
          buildPropertyItem(Icons.attach_money, 'Profit Loss', 'Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfitLossReportScreen()),
            );
          }),
          buildPropertyItem(Icons.bar_chart, 'Product Sale', 'Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsControlScreen()),
            );
          }),
          buildPropertyItem(Icons.warning, 'Damaged Materials', 'TPC', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DamagedMaterialsScreen()),
            );
          }),
          buildPropertyItem(Icons.trending_up, 'Rate', '5 kg/day', () {}),
          buildPropertyItem(
              Icons.device_thermostat, 'Temperature', '25°C', () {}),
        ],
      ),
    ],
  );
}
