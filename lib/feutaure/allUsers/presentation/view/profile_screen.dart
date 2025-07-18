import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/const.dart';
import 'package:tcp/core/util/func/alert_dilog.dart'; // لتنبيهات الأخطاء
import 'package:tcp/core/widget/appar_widget,.dart'; // للـ AppBar المخصص
import 'package:tcp/core/widget/error_widget_view.dart'; // لعرض أخطاء الجلب
import 'package:tcp/feutaure/allUsers/presentation/manger/cubit/user_cubit.dart';
import 'package:tcp/feutaure/allUsers/presentation/manger/cubit/user_state.dart';
import 'package:tcp/feutaure/allUsers/repo/user_repo.dart';

class ProfileScreen extends StatefulWidget {
  final int userId; // ID المستخدم الذي نريد عرض بروفايله

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UsersCubit _usersCubit;

  @override
  void initState() {
    super.initState();
    _usersCubit = UsersCubit(repository: UserRepoImpl(ApiService()));
    _usersCubit.fetchUserProfile(widget.userId); // جلب بيانات البروفايل فوراً
  }

  @override
  void dispose() {
    _usersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'ملف شخصي', // عنوان صفحة البروفايل
        ),
      ),
      body: BlocProvider<UsersCubit>.value(
        value: _usersCubit,
        child: BlocConsumer<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              showCustomAlertDialog(
                context: context,
                title: 'عذراً! 😢',
                content: 'فشل في تحميل الملف الشخصي: ${state.errorMessage}',
              );
            }
          },
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // توسيط المحتوى
                  children: [
                    // صورة البروفايل الدائرية
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueGrey.shade100,
                      child: Icon(Icons.person,
                          size: 80, color: Colors.blueGrey.shade600),
                    ),
                    const SizedBox(height: 20),
                    // اسم المستخدم
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // دور المستخدم (مع لون خلفية)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getRoleColor(user.userRole),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        user.userRole.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // تفاصيل المستخدم في بطاقات أنيقة
                    _buildInfoCard(
                      'معلومات الاتصال',
                      [
                        _buildProfileInfoRow(
                            Icons.email, 'البريد الإلكتروني:', user.email),
                        _buildProfileInfoRow(
                            Icons.phone, 'الهاتف:', user.phone),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      'حالة الحساب',
                      [
                        _buildProfileInfoRow(
                          Icons.verified_user,
                          'الحالة:',
                          user.flag == 1 ? 'فعال' : 'غير فعال',
                          color: user.flag == 1
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                        _buildProfileInfoRow(
                          Icons.vpn_key_outlined,
                          'معرف الـ FCM:',
                          user.fcmToken ?? 'غير متوفر',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      'تواريخ مهمة',
                      [
                        _buildProfileInfoRow(
                          Icons.calendar_today,
                          'تاريخ الإنشاء:',
                          user.createdAt.toLocal().toString().split(' ')[0],
                        ),
                        _buildProfileInfoRow(
                          Icons.update,
                          'آخر تحديث:',
                          user.updatedAt.toLocal().toString().split(' ')[0],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // زر تعديل البروفايل (اختياري)
                    ElevatedButton.icon(
                      onPressed: () {
                        // يمكنك التنقل لصفحة EditUserScreen هنا
                        // وتمرير user.id و user object
                        // final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => EditUserScreen(userId: user.id, currentUser: user)));
                        // if (result == true) { _usersCubit.fetchUserProfile(widget.userId); } // تحديث البروفايل بعد التعديل
                        showCustomAlertDialog(
                            context: context,
                            title: 'تعديل',
                            content: 'هذه الوظيفة قيد الإنشاء!');
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('تعديل الملف الشخصي',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              return Center(
                child: ErrorWidetView(
                  message: 'خطأ في تحميل الملف الشخصي: ${state.errorMessage}',
                  onPressed: () {
                    _usersCubit
                        .fetchUserProfile(widget.userId); // إعادة المحاولة
                  },
                ),
              );
            }
            return const SizedBox.shrink(); // في الحالة الأولية أو غير المتوقعة
          },
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء صف معلومات بداخل البطاقة
  Widget _buildProfileInfoRow(IconData icon, String title, String value,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.blueGrey.shade700),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء بطاقة معلومات (يمكن استخدامها لـ 'معلومات الاتصال', 'حالة الحساب', etc.)
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children, // عرض عناصر المعلومات
          ],
        ),
      ),
    );
  }
}
