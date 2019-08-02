import 'package:workout_helper/model/entities.dart';

class MovementService {

  static List<Movement> movements = List();

  MovementService(){
    movements = List();
    Movement benchPress = Movement();
    benchPress.id = "1";
    benchPress.involvedMuscle = List();
    benchPress.involvedMuscle.add(MuscleGroup.TRICEPS);
    benchPress.involvedMuscle.add(MuscleGroup.CHEST);
    benchPress.name = "Bench Press";
    benchPress.description = "Best movement for chest muscle";
    benchPress.picReference = '';
    benchPress.videoReference = '';
    movements.add(benchPress);
    Movement squat = Movement();
    squat.id = "2";
    squat.involvedMuscle = List();
    squat.involvedMuscle.addAll([
      MuscleGroup.LEG,
      MuscleGroup.QUADS,
      MuscleGroup.GLUTES,
      MuscleGroup.HAMSTRING,
      MuscleGroup.CALVES
    ]);
    squat.involvedMuscle.add(MuscleGroup.CHEST);
    squat.name = "Squat";
    squat.description = "Best movement for Leg muscle";
    squat.picReference = '';
    squat.videoReference = '';
    movements.add(squat);
  }

  List<Movement> getMovements() {
    return movements;
  }
}
