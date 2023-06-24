import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_todolistv2/models/category.dart';
import 'package:flutter_application_todolistv2/services/category_services.dart';

import '../constant/colors.dart';
import 'home_page.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Categories();
  var _categoryService = CategoryService();

  List<Categories> _categoryList = <Categories>[];

  var category;

  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();

@override
  void initState(){
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async{
    _categoryList = <Categories>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((categories){
      setState(() {
        var categoryModel = Categories();
        categoryModel.name = categories['name'];
        categoryModel.description = categories['description'];
        categoryModel.id = categories['id'];

        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editcategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editcategoryDescriptionController.text = category[0]['description'] ?? 'No Description';
    });
    _editFromDialog(context);
  }

  _showFromDialog(BuildContext context){
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
            _category.name = _categoryNameController.text;
            _category.description = _categoryDescriptionController.text;
            _categoryService.saveCategory(_category);

            var result = await _categoryService.saveCategory(_category);
            // if (result>0){
               print(result);
            //    Navigator.pop(context);
            //    getAllCategories();
            // }
        
          },
          child: Text('Save'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(tdBlue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ],
        title: const Text('Make Category'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Add New Category',
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Add Description',
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _editFromDialog(BuildContext context){
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
            _category.id = category[0]['id'];
            _category.name = _editcategoryNameController.text;
            _category.description = _editcategoryDescriptionController.text;
            _categoryService.saveCategory(_category);

            var result = await _categoryService.updateCategory(_category);
            if (result > 0){
              print(result);
              Navigator.pop(context);
              getAllCategories();
              _showSuccessSnackBar('Updated');
            }
          },
          child: Text('Update'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(tdBlue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ],
        title: Text('Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editcategoryNameController,
                decoration: InputDecoration(
                  hintText: 'Add New Category',
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _editcategoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Add Description',
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

 _deleteFromDialog(BuildContext context, categoryId){
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
            var result = await _categoryService.deleteCategory(categoryId);
            if (result > 0){
              print(result);
              Navigator.pop(context);
              getAllCategories();
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

  // _showSuccessSnackBar(message){
  //   var _snackBar = SnackBar(content: message);
  //   _globalKey.currentState?.showSnackBar(_snackBar);
  // }

  _showSuccessSnackBar(message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      key: _globalKey,
      appBar: AppBar(
        elevation: 0,
        leading: ElevatedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage())),
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
          ),
          child: Icon(Icons.arrow_back),
        ),
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length, itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.only(top:8.0, left: 8.0,right: 8.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.edit), onPressed: (){
                  _editCategory(context, _categoryList[index].id);
                },),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoryList[index].name ?? 'Default Value'),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: (){

                      _deleteFromDialog(context, _categoryList[index].id);
                    },),
                ],
                ),
                // subtitle: Text(_categoryList[index].description ?? 'Default Value'),
              ),
            ),
          );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFromDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white,
        )
      ),
    );
  }
}