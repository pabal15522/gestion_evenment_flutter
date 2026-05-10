import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_evement/models/Evenement.dart';
import 'package:gestion_evement/services/ApiService.dart';
import 'package:intl/intl.dart';

import '../config/Config.dart';
import 'EventDetailWidget.dart';

class Eventwidget extends StatefulWidget {
  const Eventwidget({super.key});

  @override
  State<Eventwidget> createState() => _EventwidgetState();
}

class _EventwidgetState extends State<Eventwidget> {
  final _apiService=ApiService();
  String _searchText = '';
  String _searchDate='';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshEvents() => setState(() {});

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _searchDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchText = '';
      _searchDate = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion évènment"),
      backgroundColor: Config.primaryColor,
      foregroundColor: Colors.white,),
      backgroundColor: Config.backGroundColor,
      body:Column(children: [
        Container(
          color: Config.primaryColor,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            children: [
              //  Champ recherche
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchText = value),
                onSubmitted: (_) => _refreshEvents(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Rechercher un évènement...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _searchText = '';
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 8),
              // Filtre date en plus de netoyage
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _searchDate.isEmpty
                                  ? 'Filtrer par date'
                                  : _searchDate,
                              style: TextStyle(
                                color: Colors.white.withOpacity(
                                    _searchDate.isEmpty ? 0.7 : 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bouton effacer filtres
                  if (_searchText.isNotEmpty || _searchDate.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _clearFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.filter_alt_off,
                                color: Colors.white, size: 18),
                            SizedBox(width: 4),
                            Text('Effacer',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Evenement>>(
            future: _apiService.eventList(_searchText, _searchDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation(Config.primaryColor),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                            size: 80, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          "Connexion réseau indisponible. Vérifiez votre connexion et réessayez.",
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 80, color: Config.primaryColor),
                      const SizedBox(height: 10),
                      const Text("Aucun évènement trouvé",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 16)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    _buildCartItem(snapshot.data![index]),
              );
            },
          ),
        ),
      ],)
    );
  }
  
  Widget _buildCartItem(Evenement event) {
    return GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Eventdetailwidget(event: event),
        ),
      );
    },
    child: Container(
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
                  const SizedBox(height: 12),
                  _infoRow(Icons.calendar_today, DateFormat('yyyy-MM-dd').format(DateTime.parse(event.date))),
                  const SizedBox(height: 8),
                  _infoRow(Icons.location_on, event.location),
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
    ));
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Config.primaryColor),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}




