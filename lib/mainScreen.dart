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
    // Mostrar un SnackBar después de agregar la tarea
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarea agregada')),
    );
  }

  // Eliminar las tareas que están marcadas como completadas.
  Future<void> _deleteTasks() async {
    final tasksToDelete = tareas.where((task) => task.isCompleted).toList();
    for (var task in tasksToDelete) {
      await tareaDao.deleteTask(task);
    }
    _loadTasks();
    // Mostrar un SnackBar después de eliminar las tareas completadas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Todas las tareas completadas han sido eliminadas')),
    );
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
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/fondo.jpg'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: const Color(0xFF582804),
          width: 15,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Gestor de tareas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Chalkboard',
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
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
        ],
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
    // Mostrar un SnackBar después de eliminar una tarea
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarea eliminada')),
    );
  }
}
