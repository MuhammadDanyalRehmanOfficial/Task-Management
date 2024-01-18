import 'package:flutter/material.dart';
import 'package:taskmanager/utils/roles.dart';
import 'package:taskmanager/utils/routes.dart';

import '../widgets/role_list_item.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          title,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your role',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            RoleListItem(
              title: Roles.admin,
              subtitle: 'Admin can perform actions like as; Create, Read, Update, and Delete tasks.',
              icon: Icons.admin_panel_settings,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.taskList,
                  arguments: Roles.admin,
                );
              },
            ),
            RoleListItem(
              title: Roles.manager,
              subtitle: 'Manager can perform actions like as; Read and Update.',
              icon: Icons.manage_accounts,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.taskList,
                  arguments: Roles.manager,
                );
              },
            ),
            RoleListItem(
              title: Roles.user,
              subtitle: 'User can perform actions like as; Read.',
              icon: Icons.person,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.taskList,
                  arguments: Roles.user,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
