import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart';

class ProfileService {

  ExerciseDatabase db = ExerciseDatabase();

  Future<List<UserBodyIndex>> loadUserIndexes(String userId) async {
      return db.getUserBodyIndexes(userId);
  }

  void updateUserIndex(UserBodyIndex userBodyIndex,String userId){
    db.updateUserIndex(userId, userBodyIndex);
  }

  void createUserIndex(UserBodyIndex userBodyIndex,String userId){
  }

}