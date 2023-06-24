import 'package:flutter_application_todolistv2/models/todo.dart';
import 'package:flutter_application_todolistv2/repositories/repository.dart';


class TodoService{
  late Repository _repository;

  TodoService(){
    _repository = Repository();
  }

  saveTodo(Todo todo) async{
    return await _repository.InsertData('todos', todo.todoMap());
  }

  readTodos() async{
    return await _repository.readData('todos');
  }

  readTodosByCategory(category) async{
    return await _repository.readDataByColumnName('todos', 'category', category);
  }

  deleteTodos(todo) async{
    return await _repository.deleteData('todos', todo);
  }

}