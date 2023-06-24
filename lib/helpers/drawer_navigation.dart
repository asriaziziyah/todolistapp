import 'package:flutter/material.dart';
import 'package:flutter_application_todolistv2/constant/colors.dart';
import 'package:flutter_application_todolistv2/screen/categories_screen.dart';
import 'package:flutter_application_todolistv2/screen/home_page.dart';
import 'package:flutter_application_todolistv2/screen/todos_by_category.dart';
import 'package:flutter_application_todolistv2/services/category_services.dart';
class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  List<Widget> _categoryList = <Widget>[];

  CategoryService _categoryService = CategoryService();

  @override
  initState(){
    super.initState();
    getAllCategories();
  }

  getAllCategories() async{
    var categories = await _categoryService.readCategories();

    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context)=>new TodosByCategory(category: category['name'],))),
          child: ListTile(
            title: Text(category['name'], style: TextStyle(color: tdBGColor),),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        backgroundColor: tdBlue,
        child: ListView(
          children: <Widget> [
            ListTile(
              leading: Icon(Icons.home, color: tdBGColor,),
              title: Text('Home', style: TextStyle(color: tdBGColor),),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage())),
            ),
            ListTile(
              leading: Icon(Icons.view_list, color: tdBGColor,),
              title: Text('Categories', style: TextStyle(color: tdBGColor),),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}