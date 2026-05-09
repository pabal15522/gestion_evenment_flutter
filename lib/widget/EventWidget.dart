import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_evement/models/Evenement.dart';
import 'package:gestion_evement/services/ApiService.dart';
import 'package:intl/intl.dart';

import '../config/Config.dart';

class Eventwidget extends StatefulWidget {
  const Eventwidget({super.key});

  @override
  State<Eventwidget> createState() => _EventwidgetState();
}

class _EventwidgetState extends State<Eventwidget> {
  final _apiService=ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion évènment"),
      backgroundColor: Config.primaryColor,),
      body: FutureBuilder<List<Evenement>>(future: _apiService.eventList(), builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation(Config.primaryColor),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return  Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height:278,
                child: Icon(Icons.access_time_sharp,
                  ),),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Connexion réseau indisponible. Veillez vérifier que vous disposer d'une connexion internet et réessayer. ${snapshot.error}",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 16),textAlign: TextAlign.center,),
              ),
            ],
          ));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Icon(Icons.calendar_today,size: 80,color: Config.primaryColor,),
              const SizedBox(height: 10,),
              const Text("Pas de d'évènement",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 16),),
            ],
          ));
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: snapshot.data!.map((planning) =>_buildCartItem(planning)).toList(),
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildCartItem(Evenement event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image:DecorationImage(fit: BoxFit.fill,image: AssetImage("assets/images/evenement.jpg")),)),
          const SizedBox(height: 5),
          Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text("Lieu : ${event.location}"),
                  Text("Date : ${DateFormat('yyyy-mm-dd').parse(event.date)}")
                ],),

                Column(children: [
                  Container(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(50)),
                  child: Column(
                    children: [
                      Center(child: Text("Capacité",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold),),),
                      Center(child: Text("${event.capacity}",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),),
                    ],
                  ),)
                ],),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Center(child: Text("Place restant ${event.capacity-event.register}"),),
          SizedBox(height: 10,),
          Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 10,
                width: event.register>0? MediaQuery.of(context).size.width*(event.register/event.capacity).clamp(0.0, 1.0):0,
                decoration: BoxDecoration(
                  color: Config.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                ),),
            ),
          )
        ],
      ),
    );
  }
}
