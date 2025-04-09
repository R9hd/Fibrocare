import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibercare/homepage.dart';
import 'package:fibercare/language_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // State management
  final ValueNotifier<bool> _isEditingName = ValueNotifier(false);
  final ValueNotifier<bool> _isEditingAge = ValueNotifier(false);
  final ValueNotifier<bool> _isEditingHeight = ValueNotifier(false);
  final ValueNotifier<bool> _isEditingWeight = ValueNotifier(false);
  final ValueNotifier<bool> _isUpdating = ValueNotifier(false);
  final ValueNotifier<Usermodel?> _currentUser = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _isEditingName.dispose();
    _isEditingAge.dispose();
    _isEditingHeight.dispose();
    _isEditingWeight.dispose();
    _isUpdating.dispose();
    _currentUser.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _currentUser.value = Usermodel.fromSnapshot(snapshot.docs.first);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load user data');
    }
  }

  Future<void> _updateField({
    required String field,
    required dynamic value,
    bool checkUnique = false,
  }) async {
    _isUpdating.value = true;
    
    try {
      if (checkUnique) {
        final exists = await FirebaseFirestore.instance
            .collection('users')
            .where(field, isEqualTo: value)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.isNotEmpty);

        if (exists) {
          Fluttertoast.showToast(msg: '${field.capitalize()} already exists');
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.value?.id)
          .update({field: value});

      _currentUser.value = _currentUser.value?.copyWith(
        username: field == 'username' ? value : _currentUser.value?.username,
        age: field == 'age' ? value : _currentUser.value?.age,
        tall: field == 'tall' ? value : _currentUser.value?.tall,
        weight: field == 'weight' ? value : _currentUser.value?.weight,
      );

      Fluttertoast.showToast(msg: 'Updated successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Update failed: ${e.toString()}');
    } finally {
      _isUpdating.value = false;
    }
  }

  Widget _buildEditableTile({
    required String title,
    required String value,
    required ValueNotifier<bool> isEditing,
    required TextEditingController controller,
    required Future<void> Function(String) onSave,
    bool isNumber = false,
    IconData? icon,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEditing,
      builder: (context, editing, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isUpdating,
          builder: (context, updating, _) {
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(
                icon ?? Icons.edit, 
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(title),
              subtitle: editing
                  ? TextField(
                      controller: controller..text = value,
                      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: value,
                      ),
                      autofocus: true,
                    )
                  : Text(value),
              trailing: updating
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(editing ? Icons.check : Icons.edit),
                      onPressed: () async {
                        if (editing) {
                          await onSave(controller.text.trim());
                          isEditing.value = false;
                        } else {
                          controller.text = value;
                          isEditing.value = true;
                        }
                      },
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildReadOnlyTile({
    required String title,
    required String value,
    IconData? icon,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: Theme.of(context).colorScheme.tertiary,
      leading: Icon(
        icon ?? Icons.info, 
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageManager.translate('personalInfo'), style: TextStyle(color: theme.colorScheme.tertiary),),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.tertiary),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFd4e8eb),
      body: ValueListenableBuilder<Usermodel?>(
        valueListenable: _currentUser,
        builder: (context, user, _) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: screenSize.width * 0.06,
              right: screenSize.width * 0.06,
              top: screenSize.height * 0.016,
              bottom: screenSize.height * 0.40,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.tertiary,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                
                // Username Field
                _buildEditableTile(
                  title: languageManager.translate('name'),
                  value: user.username ?? '',
                  isEditing: _isEditingName,
                  controller: _usernameController,
                  onSave: (value) => _updateField(
                    field: 'username',
                    value: value,
                    checkUnique: true,
                  ),
                  icon: Icons.person,
                ),
                
                SizedBox(height: screenSize.height * 0.01),
                
                // Email Field
                _buildReadOnlyTile(
                  title: languageManager.translate('email'),
                  value: user.email ?? '',
                  icon: Icons.email,
                ),
                
                SizedBox(height: screenSize.height * 0.01),
                
                // Password Field
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: theme.colorScheme.tertiary,
                  leading: Icon(Icons.lock, color: theme.colorScheme.primary),
                  title: Text(languageManager.translate('password')),
                  subtitle: const Text('********'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      if (user.email == null) return;
                      FirebaseAuth.instance.sendPasswordResetEmail(
                          email: user.email!);
                      Fluttertoast.showToast(
                        msg: languageManager.translate('passwordResetSent'),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                    },
                  ),
                ),
                
                SizedBox(height: screenSize.height * 0.01),
                
                // Age Field
                _buildEditableTile(
                  title: languageManager.translate('age'),
                  value: user.age?.toString() ?? '',
                  isEditing: _isEditingAge,
                  controller: _ageController,
                  onSave: (value) => _updateField(
                    field: 'age',
                    value: int.tryParse(value) ?? 0,
                  ),
                  isNumber: true,
                  icon: Icons.calendar_today,
                ),
                
                SizedBox(height: screenSize.height * 0.01),
                
                // Height Field
                _buildEditableTile(
                  title: languageManager.translate('height'),
                  value: user.tall?.toString() ?? '',
                  isEditing: _isEditingHeight,
                  controller: _heightController,
                  onSave: (value) => _updateField(
                    field: 'tall',
                    value: int.tryParse(value) ?? 0,
                  ),
                  isNumber: true,
                  icon: Icons.height,
                ),
                
                SizedBox(height: screenSize.height * 0.01),
                
                // Weight Field
                _buildEditableTile(
                  title: languageManager.translate('weight'),
                  value: user.weight?.toString() ?? '',
                  isEditing: _isEditingWeight,
                  controller: _weightController,
                  onSave: (value) => _updateField(
                    field: 'weight',
                    value: int.tryParse(value) ?? 0,
                  ),
                  isNumber: true,
                  icon: Icons.monitor_weight,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class Usermodel {
  final String? id;
  final String? username;
  final String? email;
  final int? age;
  final int? tall;
  final int? weight;

  Usermodel({
    this.id,
    this.username,
    this.email,
    this.age,
    this.tall,
    this.weight,
  });

  factory Usermodel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Usermodel(
      id: snapshot.id,
      username: snapshot['username'],
      email: snapshot['email'],
      age: snapshot['age'],
      tall: snapshot['tall'],
      weight: snapshot['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'age': age,
      'tall': tall,
      'weight': weight,
    };
  }

  Usermodel copyWith({
    String? username,
    String? email,
    int? age,
    int? tall,
    int? weight,
  }) {
    return Usermodel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      age: age ?? this.age,
      tall: tall ?? this.tall,
      weight: weight ?? this.weight,
    );
  }
}