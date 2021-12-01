import 'dart:async';

import 'package:todoapp_08/helpers/todo_db.dart';
import 'package:todoapp_08/models/todo_model.dart';

class TodosBloc {
// singleton:  es un patrón de diseño que permite 
//restringir la creación de objetos pertenecientes a una 
//clase o el valor de un tipo a un único objeto.

//factory: factory puede devolver una instancia de una 
//caché, o puede devolver una instancia de un subtipo. 
//Los constructores factory no tienen acceso a “this”.
  static TodosBloc _singlenton = TodosBloc.internal();
  late TodoDb db;
  List<Todo> todosList = [];

//obtener datos 
  final _todosStreamController = StreamController<List<Todo>>.broadcast();

  //para manipular/actulizar los datos 

  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  //obtener datos 
  //stream para indicar que queremos obtener datos 
  //sink para indicar que queremos enviar/agregar datos
  Stream<List<Todo>> get todosStream => _todosStreamController.stream;

 StreamSink<List<Todo>> get todosAllSink => _todosStreamController.sink;

  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  factory TodosBloc(){
    return _singlenton;
  }
  TodosBloc.internal(){
    db = TodoDb();
    getAll();

    _todosStreamController.stream.listen(returnAll);
    _todoInsertController.stream.listen(insert);
    _todoUpdateController.stream.listen(update);
    _todoDeleteController.stream.listen(delete);

  }
  /*TodosBloc(){
    
  }*/

  Future getAll() async {
    List<Todo> todos = await db.getAll();
   this.todosList = todos;

   todosAllSink.add(todos);

  }

  //obtener todos los registros 

  List<Todo> returnAll(todos){
    return todos;
  }

  void delete(Todo todo){
    db.delete(todo).then((_) => getAll());
  }

  void update(Todo todo){
    db.update(todo).then((_) => getAll());
  }

  void insert(Todo todo){
    db.insert(todo).then((_) => getAll());
  }

void dispose(){
  _todosStreamController.close();
  _todoInsertController.close();
  _todoUpdateController.close();
  _todoDeleteController.close();

}

}