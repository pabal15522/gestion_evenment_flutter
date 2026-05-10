import 'package:flutter/material.dart';
import 'package:gestion_evement/models/Evenement.dart';
import 'package:gestion_evement/widget/RegisterWidget.dart';
import '../config/Config.dart';

class Eventdetailwidget extends StatefulWidget {
  final Evenement event;
  const Eventdetailwidget({super.key, required this.event});

  @override
  State<Eventdetailwidget> createState() => _EventdetailwidgetState();
}

class _EventdetailwidgetState extends State<Eventdetailwidget> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final double progress = event.capacity > 0
        ? (event.register / event.capacity).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail évènement"),
        backgroundColor: Config.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Config.backGroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoRow(Icons.calendar_today, event.date),
                    const SizedBox(height: 8),
                    _infoRow(Icons.location_on, event.location),
                  ],
                ),
              ),
            ),

            SizedBox(height:16),


                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Inscriptions",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${event.register} inscrits"),
                            Text("${event.capacity} places"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: Colors.grey[200],
                            color: progress >= 1.0 ? Colors.red : Config.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          progress >= 1.0
                              ? "Complet"
                              : "${((1 - progress) * event.capacity).round()} places restantes",
                          style: TextStyle(
                            color: progress >= 1.0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                if (event.description != null && event.description!.isNotEmpty)
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description!,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton inscription
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: progress >= 1.0 ? null : () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Registerwidget(eventId: event.evenId,)));
                },
                label: Text(progress >= 1.0 ? "Complet" : "S'inscrire",style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Config.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Config.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}