import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_evement/models/Inscription.dart';
import 'package:gestion_evement/services/ApiService.dart';

import '../config/Config.dart';

class Registerwidget extends StatefulWidget {
  final int eventId;
  const Registerwidget({super.key, required this.eventId});

  @override
  State<Registerwidget> createState() => _RegisterwidgetState();
}

class _RegisterwidgetState extends State<Registerwidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  final apiService=ApiService();
  bool _isLoading = false;
  Future<void> _registration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

     try {
       final result=await apiService.register(widget.eventId,Inscription(firstName: _firstNameController.text,lastName: _lastNameController.text,email: _emailController.text));

       await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: Icon( result['success'] ? Icons.check_circle : Icons.error,
                color: result['success'] ? Colors.green : Colors.red, size: 48),
            title: const Text('Inscription'),
            content: Text(result['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (result['success']) Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController=TextEditingController(text: "");
    _lastNameController=TextEditingController(text: "");
    _emailController=TextEditingController(text: "");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription"),
        backgroundColor: Config.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Config.backGroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 20),

              // Formulaire
              _buildFormField(
                controller:_lastNameController ,
                label: 'Nom',
                icon: Icons.badge,
                enabled: true,
              ),
              const SizedBox(height: 15),

              _buildFormField(
                controller: _firstNameController,
                label: 'Prénom (s)',
                icon: Icons.person,
                enabled: true,
              ),
              const SizedBox(height: 15),

              _buildFormField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.mail,
                enabled: true,
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Le champ "$label" est obligatoire';
        }
        return null;
      },
    );
  }
}
