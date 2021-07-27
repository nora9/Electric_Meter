
import 'package:conditional_builder/conditional_builder.dart';
import 'package:electric_meter/shared/components/components.dart';
import 'package:electric_meter/shared/cubit/cubit.dart';
import 'package:electric_meter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllRecords extends StatefulWidget {
  @override
  _AllRecordsState createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var allRecords = AppCubit.get(context).allRecodrs;
        return ConditionalBuilder(
          condition: allRecords.length>0,
          builder: (context) => ListView.separated(
            itemBuilder:(BuildContext context, int index)=>bulidTaskItem(allRecords[index],context),
            separatorBuilder:(BuildContext context, int index) => Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            itemCount:allRecords.length ,
          ),
          fallback:(context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                  'No Records',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ) ,
        );
      }
    );
  }
}
