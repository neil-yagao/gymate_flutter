import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/service/current_user_store.dart';

abstract class SelfEvent {

  bool isSelf(context, UserEvent ue){
    User currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    bool isSelf = false;
    if (ue.user.id == currentUser.id) {
      isSelf = true;
    }
    return isSelf;
  }
}