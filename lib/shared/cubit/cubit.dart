
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:electric_meter/modules/all_records.dart';
import 'package:electric_meter/modules/new_record.dart';
import 'package:electric_meter/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super (AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex=0;

  List<Widget> screens=[
    NewRecord(),
    AllRecords()
  ];

  List<String> titles=[
    'New Record',
    'All Records',
  ];


  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  Database database;
  List<Map> allRecodrs=[];

  void createDatabase(){
    openDatabase(
        'electric.db',
        version: 1,
        onCreate: (database,version) async{
          print('database created');
          database.execute(
              'CREATE TABLE records (id INTEGER PRIMARY KEY, referenceNumber TEXT, urlImage File , lat DOUBLE, long DOUBLE)'
          ).then((value){
            print('table create');
          }).catchError((error){
            print('Error When Creating Table ${error.toString()}');
          });
        },
        onOpen: (database){
          getDataFromDatabase(database);
          print('database opened');
        }
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });

  }

  Future insertToDatabase({@required referenceNumber, @required urlImage , @required lat,@required long,})async{
    return await database.transaction((txn){
      txn.rawInsert(
          'INSERT INTO records(referenceNumber, urlImage, lat , long) VALUES("${referenceNumber}","${urlImage}", "${lat}", "${long}")'
      ).then((value){
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error){
        print('Error When Inserting New Record ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database){
    allRecodrs=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM records').then((value){
      value.forEach((element) {
        allRecodrs.add(element);
      });
      print(value);
      print("------------------------------------------------");
      print(allRecodrs[0]['urlImage'].runtimeType);
      print((Image.file(File(allRecodrs[0]['urlImage']))).runtimeType);
      emit(AppGetDatabaseState());
    });
  }


  void DeleteData({@required int id,})async{
    database.rawDelete(
        'DELETE FROM records WHERE id = ?',
        [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}