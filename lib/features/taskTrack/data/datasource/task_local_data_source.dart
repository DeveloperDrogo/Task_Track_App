import 'package:hive/hive.dart';
import 'package:task_track_app/features/taskTrack/data/model/task_model.dart';

abstract interface class TaskLocalDataSource {
  void uploadLocalTask({required List<TaskModel> tasks});
  List<TaskModel> loadTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box box;
  TaskLocalDataSourceImpl(this.box);
  @override
  List<TaskModel> loadTasks() {
    List<TaskModel> tasks = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        tasks.add(
          TaskModel.fromJson(
            box.get(
              i.toString(),
            ),
          ),
        );
      }
    });
    return tasks;
  }

  @override
  void uploadLocalTask({required List<TaskModel> tasks}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < tasks.length; i++) {
        box.put(i.toString(), tasks[i].toJson());
      }
    });
  }
}
