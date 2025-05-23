import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:streamr/auth/auth_service.dart';
import 'package:streamr/screens/login_screen.dart';

import '../bloc/cubits/drawer/drawer_navigation_cubit.dart';
import '../bloc/cubits/favorites/favorites_cubit.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
        ),
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: _drawerListViewWidget(context),
        ),
      ),
    );
  }

  Widget _drawerListViewWidget(BuildContext context) {
    final drawerItems = [
      DrawerItem(
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedHome03,
          color: Colors.indigoAccent,
        ),
        name: "H O M E",
        onTap: () {
          context.read<DrawerNavigationCubit>().setPage(0);
          Navigator.pop(context);
        },
      ),
      // DrawerItem(
      //   icon: const HugeIcon(
      //     icon: HugeIcons.strokeRoundedProfile02,
      //     color: Colors.orangeAccent,
      //   ),
      //   name: "P R O F I L E",
      //   onTap: () {
      //     context.read<DrawerNavigationCubit>().setPage(1);
      //
      //     Navigator.pop(context);
      //     Navigator.pushNamed(context, '/profile');
      //   },
      // ),

      DrawerItem(
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedHeartAdd,
          color: Colors.orangeAccent,
        ),
        name: "F A V O R I T E S",
        onTap: () {
          context.read<DrawerNavigationCubit>().setPage(1);

          Navigator.pop(context);
        },
      ),
      DrawerItem(
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedDeleteThrow,
          color: Colors.redAccent,
        ),
        name: "D E L E T E  C A C H E",
        onTap: () async {
          context.read<FavoritesCubit>().clearFavorites();
          context.read<FavoritesCubit>().loadFavorites();
          // Show a confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cache cleared"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        },
      ),
      DrawerItem(
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedLogout05,
          color: Colors.pinkAccent,
        ),
        name: "L O G O U T",
        onTap: () async {
          final _authService = AuthService();
          await _authService.signOut();
          // Show a confirmation

          // context.read<FavoritesCubit>().loadFavorites();
          // context.read<DrawerNavigationCubit>().setPage(0); // 🧠 Reset to HOME

          if (context.mounted) {
            context.read<FavoritesCubit>().loadFavorites();
            context.read<DrawerNavigationCubit>().setPage(0);

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User is Logged-out"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
      // Add more items here
    ];

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.075,
        ),
        const Center(
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"),
            radius: 50,
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.0125,
        ),
        Text(
          "Yehia El-Kenany",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 2,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.005,
        ),
        Text(
          "elkenanyyehia@gmail.com",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 2,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.075,
        ),
        ...List.generate(
          drawerItems.length,
          (index) {
            final item = drawerItems[index];
            return _drawerListTileWidget(
              leadingIcon: item.icon,
              listTileName: item.name,
              onTap: item.onTap,
            );
          },
        )
      ],
    );
  }

  Widget _drawerListTileWidget(
      {required HugeIcon leadingIcon,
      required String listTileName,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: leadingIcon,
      title: Text(listTileName),
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

// Drawer Model
class DrawerItem {
  final HugeIcon icon;
  final String name;
  final VoidCallback onTap;

  DrawerItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });
}
