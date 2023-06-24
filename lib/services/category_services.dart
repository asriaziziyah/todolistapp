// import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';

import 'package:flutter_application_todolistv2/models/category.dart';
import 'package:flutter_application_todolistv2/repositories/repository.dart';

class CategoryService{
  late Repository _repository;

  CategoryService(){
    _repository = Repository();
  }

  saveCategory(Categories category)async{
    return await _repository.InsertData('categories', category.categoryMap());
  }

  readCategories() async{
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId) async{
    return await _repository.readDatabyId('categories', categoryId);
  }

  updateCategory(Categories category) async{
    return await _repository.updateData('categories', category.categoryMap());
  }

  deleteCategory(categoryId) async{
    return await _repository.deleteData('categories', categoryId);
  }
}