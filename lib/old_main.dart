import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class TodoistTaskApp extends StatefulWidget {
  @override
  _TodoistTaskAppState createState() => _TodoistTaskAppState();
}

class _TodoistTaskAppState extends State<TodoistTaskApp> {
  final String apiUrl = "https://api.todoist.com/rest/v2/tasks";
  final String apiToken =
      "275d9ffa195a8351367369f78e03f6a49e5dba6d"; // Replace with your API token

  bool isLoading = false;
  String date = '';
  List<Map<String, dynamic>> tasks = []; // List to store tasks

  Future<void> saveUpdatedTime(String taskId, String updatedTime) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current map or initialize an empty one
    final updatedTimesString = prefs.getString('updated_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));

    // Add or update the updated time for the task
    updatedTimes[taskId.toString()] = updatedTime;

    // Save the updated map back to SharedPreferences
    await prefs.setString('updated_times', json.encode(updatedTimes));
  }

  Future<String?> getUpdatedTime(String taskId) async {
    print(taskId);
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the stored map
    final updatedTimesString = prefs.getString('updated_times') ?? '{}';
    final Map<String, String> updatedTimes =
        Map<String, String>.from(json.decode(updatedTimesString));
    print(updatedTimesString);
    // Return the updated time for the task, if it exists
    return updatedTimes[taskId.toString()];
  }

  Future<Map<String, String>> getAllUpdatedTimes() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the stored map or return an empty one if not found
    final updatedTimesString = prefs.getString('updated_times') ?? '{}';
    print(updatedTimesString);
    return Map<String, String>.from(json.decode(updatedTimesString));
  }

  // Fetch all tasks from Todoist
  Future<void> fetchTasks() async {
    try {
      setState(() {
        isLoading = true;
      });

      final Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $apiToken";

      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        setState(() {
          tasks = List<Map<String, dynamic>>.from(response.data);
          //  print('The tasks are: $tasks');
        });
      } else {
        _showSnackBar("Failed to fetch tasks.");
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("An error occurred while fetching tasks.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Insert a new task
  Future<void> insertTask(String taskContent, String dueDate) async {
    try {
      setState(() {
        isLoading = true;
      });

      final Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $apiToken";
      dio.options.headers["Content-Type"] = "application/json";

      final taskData = {
        "content": taskContent,
        "due_string": dueDate,
        "priority": 4,
        "project_id": 2344765751,
        "custom_reference": "i checking it work or not it is work fine"
      };

      final response = await dio.post(apiUrl, data: taskData);

      print('response is ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        final id = response.data['id']; // Extract the 'id' field
        saveUpdatedTime(id, DateTime.now().toString());
        _showSnackBar("Task created successfully!");
        fetchTasks(); // Refresh the task list
      } else {
        _showSnackBar("Failed to create task.");
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("An error occurred while creating the task.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show a snackbar for feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addTodoistLabel() async {
  Dio dio = Dio();
  var uuidGenerator = Uuid();

  String tempId = uuidGenerator.v4(); // Generate a unique temp ID
  String uuid = uuidGenerator.v4();  // Generate a UUID for your specific request

  try {
    final response = await dio.post(
      'https://api.todoist.com/sync/v9/sync',
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      ),
      data: {
        'commands': [
          {
            'type': 'label_add',
            'temp_id': tempId,
            'uuid': uuid,
            'args': {'name': 'Food'}
          }
        ],
      },
    );

    print('Response data: ${response.data}');
  } catch (e) {
    print('Error: $e');
  }
}

  // Delete a task
  void deleteTask(String taskId) async {
    try {
      setState(() {
        isLoading = true;
      });

      final Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $apiToken";

      final response = await dio.delete('$apiUrl/$taskId');

      if (response.statusCode == 204) {
        _showSnackBar("Task deleted successfully!");
        fetchTasks(); // Refresh the task list
      } else {
        _showSnackBar("Failed to delete task.");
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("An error occurred while deleting the task.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> moveTask(String taskId, String projectId) async {
    try {
      var response = await Dio().post(
        "https://api.todoist.com/sync/v9/sync",
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
        data: {
          "commands": [
            {
              "type": "item_move",
              "args": {"id": taskId, "project_id": projectId},
              "uuid": const Uuid().v4(),
            },
          ],
        },
      );
      saveUpdatedTime(taskId, DateTime.now().toString());
      return response.statusCode == 200; // Check for success status
    } catch (e) {
      print("Error moving task: $e");
      return false;
    }
  }

  Future<bool> completeTaks(String taskId) async {
    try {
      var response = await Dio().post(
        "https://api.todoist.com/rest/v2/tasks/$taskId/close",
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );
      return response.statusCode == 200; // Check for success status
    } catch (e) {
      print("Error completing task: $e");
      return false;
    }
  }


  Future<bool> completedTask() async {
    try {
      var response = await Dio().post(
        "https://api.todoist.com/sync/v9/completed/get_all",
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );
      // print('respons is ${response.data}');
      return response.statusCode == 200; // Check for success status
    } catch (e) {
      print("Error fetching completed task: $e");
      return false;
    }
  }

  Future<bool> getAllLables() async {
    try {
      var response = await Dio().get(
        "https://api.todoist.com/rest/v2/labels",
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
        ),
      );
       print('lables are ${response.data}');
      return response.statusCode == 200; // Check for success status
    } catch (e) {
      print("Error fetching lables: $e");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    addTodoistLabel();
    getAllLables();
    completedTask();
    fetchTasks(); // Fetch tasks when the app starts
    getAllUpdatedTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todoist Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchTasks, // Refresh tasks
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text("No tasks available."))
              : Column(
                  children: [
                    EasyDateTimeLine(
                      headerProps: EasyHeaderProps(
                        showHeader: true
                      ),
                      dayProps: EasyDayProps(
                        height: 80,
                        todayStyle: DayStyle(
                          dayStrStyle: TextStyle()
                        )
                      ),
                      onDateChange: (date) {
                        
                      },
                      initialDate: DateTime.now(),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Column(
                            children: [
                              FutureBuilder<String?>(
                                future: getUpdatedTime(
                                    task['id']), // Call the function
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Display a loading spinner while waiting
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error: ${snapshot.error}'); // Display error if any
                                  } else if (snapshot.hasData) {
                                    return Text(
                                        'Updated Time: ${snapshot.data}'); // Display the returned updated time
                                  } else {
                                    return Text(
                                        'No updated time available'); // Display message if no data
                                  }
                                },
                              ),
                              ListTile(
                                title: Text(task['content']),
                                subtitle: Text(
                                  task['due']?['string'] ?? "No due date",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Wrap(
                                  spacing: 12, // space between icons
                                  children: [
                                    Icon(
                                      task['is_completed'] == true
                                          ? Icons.check_circle
                                          : Icons.pending,
                                      color: task['is_completed'] == true
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      color: Colors.blue,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Move Task"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    title: const Text(
                                                        "Move to Not Started"),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      moveTask(
                                                        task['id'],
                                                        '2344765751', // Not Started project ID
                                                      );
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Move to To Do"),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      moveTask(
                                                        task['id'],
                                                        '2344765757', // To Do project ID
                                                      );
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Move to Completed"),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      moveTask(
                                                        task['id'],
                                                        '2344765762', // Completed project ID
                                                      );
                                                      completeTaks(task['id']);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Confirm Delete"),
                                              content: const Text(
                                                  "Are you sure you want to delete this task?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    deleteTask(task['id']);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final taskController = TextEditingController();
              DateTime selectedDate = DateTime.now();
              return AlertDialog(
                title: const Text("Add Task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      decoration:
                          const InputDecoration(hintText: "Task content"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            final DateTime dueDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            // Format the due date as a string
                            String formattedDateTime =
                                "${dueDate.toLocal()}".split(' ')[0];
                            setState(() {
                              date = formattedDateTime;
                            });
                          }
                        }
                      },
                      child: const Text("Select Due Date"),
                    ),
                    const SizedBox(height: 10),
                    Text("Selected Date: $date"),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      final String taskContent = taskController.text.trim();
                      if (taskContent.isNotEmpty) {
                        insertTask(taskContent, date);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add Task"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance(); // Safe to call here
  runApp(MaterialApp(
    home: TodoistTaskApp(),
  ));
}
