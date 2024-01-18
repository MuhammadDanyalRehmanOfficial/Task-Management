class Roles {
  static const String admin = 'Admin';
  static const String manager = 'Manager';
  static const String user = 'User';

  // Define permissions
  static const String create = 'create';
  static const String read = 'read';
  static const String edit = 'edit';
  static const String delete = 'delete';

  // Map roles to their permissions
  static Map<String, List<String>> rolePermissions = {
    admin: [create, read, edit, delete],
    manager: [read, edit],
    user: [read],
  };
  
}
