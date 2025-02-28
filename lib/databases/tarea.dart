import 'package:floor/floor.dart';

@entity
class Tarea {
  @PrimaryKey(autoGenerate: true) // Definimos id como clave primaria
  final int? id;

  final String title; // Título de la tarea.
  final bool isCompleted; // Estado de la tarea.

  // Constructor de la clase con parámetros obligatorios y con el estado
  //de incompleta
  Tarea({this.id, required this.title, this.isCompleted = false});

  // El método copyWith en la clase Tarea permite crear una nueva instancia
  //de Tarea basada en una existente, pero con la opción de modificar uno o más
  //atributos sin alterar los demás.
  Tarea copyWith({int? id, String? title, bool? isCompleted}) {
    return Tarea(
      id: id ??
          this.id, // Mantiene el id original si no se proporciona uno nuevo.
      title: title ??
          this.title, // Mantiene el título original si no se proporciona uno nuevo.
      isCompleted: isCompleted ??
          this.isCompleted, // Mantiene el estado original si no se proporciona uno nuevo.
    );
  }
}
