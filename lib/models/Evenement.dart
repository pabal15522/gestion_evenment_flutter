class Evenement{
  final int evenId;
  final String title;
  String? description;
  final String date;
  final String location;
  final int capacity;
  final int register;
  Evenement({required this.evenId,required this.title,required this.location,required this.capacity,required this.date,required this.register,this.description});

  factory Evenement.fromJson(Map<String,dynamic> json){
    return Evenement(
        evenId: json['id'],
        title: json['title'],
        location: json['location'],
        capacity: json['capacity'],
        date: json['date'],
        description: json['description'],
       register: json['inscriptions_count']
    );
  }
}