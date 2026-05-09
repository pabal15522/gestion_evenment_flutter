class Inscription{
  final String firstName;
  final DateTime lastName;
  final String email;
  Inscription({required this.firstName,required this.lastName,required this.email});

  factory Inscription.fromJson(Map<String,dynamic> json){
    return Inscription(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email']
    );
  }
}