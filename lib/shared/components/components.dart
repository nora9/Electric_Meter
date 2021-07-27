import 'dart:io';

import 'package:electric_meter/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget bulidTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Image.file(File(model['urlImage']))
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Number: ${model['referenceNumber'].toString()}",
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Latitude:  ${model['lat'].toString()}",
                style: TextStyle(fontSize: 13.0,color: Colors.grey),
              ),
              Text(
                "Longitude: ${model['long'].toString()}",
                style: TextStyle(fontSize: 13.0,color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).DeleteData(id: model['id']);
  },
);