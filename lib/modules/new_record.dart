import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:electric_meter/shared/cubit/cubit.dart';
import 'package:electric_meter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class NewRecord extends StatefulWidget {
  @override
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  final _formKey = GlobalKey<FormState>();
  File image;
  final picker =ImagePicker();
  String str;

  Position currentLocation;
  var lat;
  var long;

  final numberController = TextEditingController();

  Future getPermission() async{
    bool services;
    LocationPermission per;

    services = await Geolocator.isLocationServiceEnabled();         // location is on or off
    if (services==false){
      AwesomeDialog(
          context: context ,
          title: 'Services' ,
          body: Text('Services Not Enabled'))..show();
    }

    per = await Geolocator.checkPermission();             // is allow to use location or not
    if (per == LocationPermission.denied) {
      per = await Geolocator.requestPermission();
      // navigate to login page
    }
    return per;
  }
  Future<void> getPosition() async{
    currentLocation = await Geolocator.getCurrentPosition().then((value) => value);
    lat = currentLocation.latitude;
    long = currentLocation.longitude;
    setState(() {
    });
  }
  
  Future getImage(ImageSource src) async{
    final pickedFile = await picker.pickImage(source: src);
    setState(() {
      if(pickedFile != null){
        image = File(pickedFile.path);
        str = image.path.split('/').last;
        print(str);
      }else{
        print('no image');
      }
    });
  }

  @override
  void initState() {
    getPermission();
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: Icon(Icons.add),
            onPressed: (){
              print("lat is " "${lat.toString()}");
              print("lang is " "${long.toString()}");
              print("image is " "${str}");
              print("number is " "${numberController.text}");
              cubit.insertToDatabase(
                  referenceNumber: numberController.text,
                  urlImage: image.path,
                  lat : lat,
                  long: long
              );
            },
          ),
          body: Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Form(
                key: _formKey,
                child: ListView(
                 children: [
                   Text('Reference Number' , style: TextStyle(color: Color(0xff3d5a96), fontSize: 16),),
                   TextFormField(
                     controller: numberController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                         floatingLabelBehavior: FloatingLabelBehavior.always,
                         contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                         isDense: true,
                         enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(5),
                             borderSide: BorderSide(color: Colors.indigo,width: 0.8)),
                         focusedBorder:OutlineInputBorder(
                           borderSide: const BorderSide(color: Colors.indigo, width: 0.8),
                           //borderRadius: BorderRadius.circular(25.0),
                         ),
                         filled: true,
                         fillColor: Colors.white,
                         focusColor: Colors.indigo,
                     ),
                   ),
                   SizedBox(height: 10,),
                   Text('Photo of Electric Meter' , style: TextStyle(color: Color(0xff3d5a96), fontSize: 16),),
                   TextFormField(
                     keyboardType: TextInputType.text,
                     readOnly: true,
                     decoration: InputDecoration(
                       hintText: str,
                       hintStyle: TextStyle(color: Colors.black , fontSize: 12),
                       floatingLabelBehavior: FloatingLabelBehavior.always,
                       contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                       isDense: true,
                       enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: BorderSide(color: Colors.indigo,width: 0.8)),
                       focusedBorder:OutlineInputBorder(
                         borderSide: const BorderSide(color: Colors.indigo, width: 0.8),
                         //borderRadius: BorderRadius.circular(25.0),
                       ),
                       filled: true,
                       fillColor: Colors.white,
                       focusColor: Colors.indigo,
                         suffixIcon: IconButton(
                           icon: Icon(Icons.camera_alt),
                           onPressed: (){
                             print(lat);
                             print(long);
                             showDialog(
                                 context: context,
                                 builder: (BuildContext context) => AlertDialog(
                                   title: Text('Choose Picture From :'),
                                   content: Container(
                                     height: 150,
                                     child: Column(
                                       children: [
                                         Divider(color: Colors.black,),
                                         Container(
                                           color: Colors.indigo,
                                           child: ListTile(
                                             leading: Icon(Icons.image),
                                             title: Text('Gallery'),
                                             onTap: (){
                                               getImage(ImageSource.gallery);
                                               Navigator.of(context).pop();
                                             },
                                           ),
                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           color: Colors.indigo,
                                           child: ListTile(
                                             leading: Icon(Icons.add_a_photo),
                                             title: Text('Camera'),
                                             onTap: (){
                                               getImage(ImageSource.camera);
                                               Navigator.of(context).pop();
                                             },
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),                           )
                             );
                           }
                       )
                     ),
                   ),
                   SizedBox(height: 10,),
                   Container(
                     child: image==null? Text('no image') : Image.file(image),
                   )
                 ],
                ),
              ),
            ),
        );
      },
    );
  }
}
