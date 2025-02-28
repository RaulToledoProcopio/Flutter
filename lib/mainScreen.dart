import 'package:flutter/material.dart';
import 'databases/database.dart';
import 'databases/tarea.dart';
import 'databases/tareaDao.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late AppDatabase database; // Instancia de la base de datos.
  late TareaDao tareaDao; // Instancia del DAO de Tarea.
  List<Tarea> tareas = []; // Lista para almacenar las tareas.

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Inicializamos la base de datos cuando la pantalla se construye.
  }

  // Inicializamos la base de datos y obtenemos la referencia del DAO.
  Future<void> _initializeDatabase() async {
    database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build(); // Creamos la base de datos.
    tareaDao =
        database.tareaDao; // Asignamos el DAO para las operaciones de Tarea.
    _loadTasks(); // Cargamos las tareas después de inicializar la base de datos.
  }

  // Cargamos todas las tareas desde la base de datos.
  Future<void> _loadTasks() async {
    final taskList = await tareaDao.getAllTasks();
    setState(() {
      tareas = taskList; // Actualiza la lista de tareas en el estado.
    });
  }

  // Agregar una nueva tarea a la base de datos.
  Future<void> _addTask(String title) async {
    final newTask = Tarea(title: title);
    await tareaDao.insertTask(newTask);
    _loadTasks();
  }

  // Eliminar las tareas que están marcadas como completadas.
  Future<void> _deleteTasks() async {
    final tasksToDelete = tareas.where((task) => task.isCompleted).toList();
    for (var task in tasksToDelete) {
      await tareaDao.deleteTask(task);
    }
    _loadTasks();
  }

  // Cambiar el estado de completado de una tarea.
  Future<void> _toggleCompletion(Tarea task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await tareaDao.updateTask(updatedTask);
    _loadTasks();
  }

  // Formato de la pantalla principal
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0e4935),
          border: Border.all(
            color: const Color(0xFF582804),
            width: 15,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'Gestión de Tareas',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF0e4935),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF582804),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    String? title = await _showTaskDialog(context);
                    if (title != null && title.isNotEmpty) {
                      _addTask(title);
                    }
                  },
                  child: const Text('Añadir Tarea'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final task = tareas[index];
                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleCompletion(task),
                        activeColor: Colors.white,
                        checkColor: const Color(0xFF0e4935),
                      ),
                      title: Text(
                        task.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Chalkboard',
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => _deleteTask(task),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF582804),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _deleteTasks,
                  child: const Text('Eliminar Tareas Completadas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Cuadro de diálogo para ingresar el título de una nueva tarea.
  Future<String?> _showTaskDialog(BuildContext context) async {
    TextEditingController controller =
        TextEditingController(); // Controlador para el campo de texto.
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0e4935),
          title: const Text(
            'Nueva Tarea', // Título del cuadro de diálogo.
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller, // Controlador del campo de texto.
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Título de la tarea',
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller
                    .text); // Cierra el cuadro de diálogo y devuelve el texto.
              },
              child:
                  const Text('Añadir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Eliminar una tarea individual de la base de datos.
  Future<void> _deleteTask(Tarea task) async {
    await tareaDao.deleteTask(task);
    _loadTasks();
  }
}
