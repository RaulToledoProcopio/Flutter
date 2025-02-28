import 'package:floor/floor.dart';
import 'tarea.dart';

@dao
abstract class TareaDao {
  @Query(
      'SELECT * FROM Tarea ORDER BY id DESC') // Consulta SQL para obtener todas las tareas
  Future<List<Tarea>>
      getAllTasks(); // Devuelve una lista de tareas en un Future.

  @insert
  Future<void> insertTask(Tarea task);

  @update
  Future<void> updateTask(Tarea task);

  @delete
  Future<void> deleteTask(Tarea task);
}
