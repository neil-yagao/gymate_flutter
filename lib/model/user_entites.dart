
import 'entities.dart';

class UserGroup {

  int id;

  String name;

  String code;

  User createdBy;

  int groupUserNumber;

  UserGroup(this.id, this.name, this.code);

  UserGroup.empty();
}