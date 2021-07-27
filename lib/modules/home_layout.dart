import 'package:electric_meter/shared/cubit/cubit.dart';
import 'package:electric_meter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey= GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            /*appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
            ),*/
            body: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => state is !AppGetDatabaseLoadingState,
              widgetBuilder: (BuildContext context) => cubit.screens[cubit.currentIndex],
              fallbackBuilder: (BuildContext context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar:BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.edit
                  ),
                  label: 'New Record',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.notes
                  ),
                  label: 'All Records',
                ),
              ],
            ) ,
          );
        },

      ),
    );
  }


}