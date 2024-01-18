import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onDelete;
  final Function(String) onEditStatus;
  final String userRole;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onEditStatus,
    required this.userRole,
  }) : super(key: key);

  Color getStatusColor() {
    switch (task.status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'to do':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (task.status.toLowerCase()) {
      case 'completed':
        return Icons.check;
      case 'in progress':
        return Icons.access_time;
      case 'to do':
        return Icons.list;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> permissions = Roles.rolePermissions[userRole] ?? [];

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.taskDetails,
            arguments: {'task': task, 'userRole': userRole},
          );
        },
        leading: Icon(
          getStatusIcon(),
          color: getStatusColor(),
          size: 32,
        ),
        title: Text(
          task.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          itemBuilder: (context) {
            return [
              if (permissions.contains(Roles.edit))
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
              if (permissions.contains(Roles.delete))
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
            ];
          },
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEditStatus(task.id.toString());
                break;
              case 'delete':
                onDelete(task.id.toString());
                break;
            }
          },
        ),
      ),
    );
  }
}