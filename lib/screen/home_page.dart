import 'package:flutter/material.dart';
import 'package:flutter_application_todolistv2/screen/todo_screen.dart';
import 'package:flutter_application_todolistv2/services/todo_services.dart';
import 'package:flutter_application_todolistv2/models/todo.dart';

import '../constant/colors.dart';
import '../helpers/drawer_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}
  // This widget is the root of your application.
class _HomePageState extends State<HomePage> {
  // final todosList = Todo.todoMap();
  List<Todo> _foundToDo = [];
  late TodoService _todoService;
  
  List<Todo> _todoList = <Todo>[];

  late String _searchQuery = "";

  // void setSearchQuery(String query) {
  //   setState(() {
  //     _searchQuery = query.toLowerCase();
  //   });
  // }

  List<Todo> _getVisibleTodos() {
    return _todoList.where((todo) {
      final title = todo.title?.toLowerCase() ?? "";
      return title.contains(_searchQuery);
    }).toList();
  }

  @override
  initState(){
    super.initState();
    getAllTodos();
    _foundToDo = _todoList;
  }

  getAllTodos() async{
    _todoService = TodoService();
    _todoList = <Todo>[];
  
  var todos = await _todoService.readTodos();



  todos.forEach((todo){
    setState(() {
      var model = Todo();
      model.id = todo['id'];
      model.title = todo['title'];
      model.description = todo['description'];
      model.category = todo['category'];
      model.todoDate = todo['todoDate'];
      // model.isFinished = todo['isFinished'];
      model.isDone = todo['isDone'] == 1 ? true : false;

      _todoList.add(model);
    });
  });

  }

  _showSuccessSnackBar(message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
  }

   _deleteFromDialog(BuildContext context, todo){
    showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
        TextButton(
          onPressed: ()=>Navigator.pop(context),
          child: Text('Cancel'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(tdGrey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async{
            var result = await _todoService.deleteTodos(todo);
            if (result > 0){
              print(result);
              Navigator.pop(context);
              getAllTodos();
              _showSuccessSnackBar('Deleted');
            }
          },
          child: Text('Delete'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ],
        title: Text('Are you sure want to delete this?'),
      );
    });
  }

// void _handleToDoChange(Todo? todo) {
//   if (todo != null) {
//     setState(() {
//       todo.isDone = false;
//     });
//   }
// }

void _handleToDoChange(Todo? todo) {
  if (todo != null) {
    setState(() {
      if (todo.isDone == true) {
        todo.isDone = false;
      } else {
        todo.isDone = true;
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('ToDo App'),
        centerTitle: true,
      ),
      drawer: DrawerNavigation(),
      body: Container(
                    padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
        child: Column(
          children: [
            searchBox(),
            Expanded
            (
              child: ListView.builder(
                // itemCount: _getVisibleTodos().length,
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                // final todo = _getVisibleTodos()[index];
                // // final todo = _todoList[index];
                return Padding(
                  padding: const EdgeInsets.only(top:8.0, left:0.0, right:0.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                      ),
                    child: ListTile(
                        leading: Icon( 
                        _todoList[index].isDone == true
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                        color: tdBlue,
                        ),
                        onTap: (){
                          _handleToDoChange(_todoList[index]);
                        },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(_todoList[index].title ?? 'No Title',
                          style: TextStyle(
                              decoration: _todoList[index].isDone == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(_todoList[index].category ?? 'No Category'),
                          Text(_todoList[index].todoDate ?? 'No Date'),
                        ],
                      ), 
                      // subtitle: Text(_todoList[index].category ?? 'No Category'),
                      // trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                      trailing: 
                          IconButton(icon: Icon(Icons.close, color: Colors.grey,), onPressed: (){
                              _deleteFromDialog(context, _todoList[index].id);
                            },),
                      // trailing: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       // Text(_todoList[index].todoDate ?? 'No Date'),
                      //       IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: (){
                      //         // _deleteFromDialog(context, _categoryList[index].id);
                      //       },),
                      //   ],
                      // ),
                      // trailing: Container(
                      //   padding: EdgeInsets.all(0),
                      //   margin: EdgeInsets.symmetric(vertical: 12),
                      //   height: 35,
                      //   width: 35,
                      //   decoration: BoxDecoration(
                      //   color: tdRed,
                      //   borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   child: IconButton(
                      //     color: Colors.white,
                      //     iconSize: 18,
                      //     icon: Icon(Icons.delete),
                      //     onPressed: () {
                      //       // print('Clicked on delete icon');
                      //       // onDeleteItem(todo.id);
                      //     },
                      //   ),
                      //   ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TodoScreen())),
        child: Icon(Icons.add),
      ),

    );
  }    

    void _runFilter(String enteredKeyword) {
    List<Todo> results = [];
    if (enteredKeyword.isEmpty) {
      results = _todoList;
    } else {
      results = _todoList
          .where((item) => item.title!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }


  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

}