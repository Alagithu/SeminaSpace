import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class AddSallePage extends StatefulWidget {
  const AddSallePage({super.key});

  @override
  State<AddSallePage> createState() => _AddSallePageState();
}

class _AddSallePageState extends State<AddSallePage> {
  final _formKey = GlobalKey<FormState>();

  String? ville;
  String? price;
  String? surface;
  String? description;

  Uint8List? _imageData;
  String? _imageName;

  bool _isSaving = false;
  double _uploadProgress = 0;

  final List<String> _villes = [
    "Sousse",
    "Monastir",
    "Mahdia",
    "Tunis",
    "Sfax",
    "Nabeul",
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List bytes = await image.readAsBytes();

      img.Image? decoded = img.decodeImage(bytes);
      if (decoded != null) {
        img.Image resized = img.copyResize(decoded, width: 600, height: 600);
        Uint8List compressed = Uint8List.fromList(
          img.encodeJpg(resized, quality: 70),
        );

        setState(() {
          _imageData = compressed;
          _imageName = image.name;
        });
      }
    }
  }

  Future<void> _uploadImageAndUpdate(String docId) async {
    if (_imageData == null) return;

    try {
      final ref = FirebaseStorage.instance.ref(
        'salles/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final uploadTask = ref.putData(_imageData!);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('salles').doc(docId).update({
        'imageUrl': url,
      });
    } catch (e) {
      debugPrint('Erreur upload image : $e');
    } finally {
      setState(() {
        _isSaving = false;
        _uploadProgress = 0;
        _imageData = null;
        _imageName = null;
        ville = null;
        price = null;
        surface = null;
        description = null;
      });
    }
  }

  Future<void> _saveSalle() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    try {
      final docRef = await FirebaseFirestore.instance.collection('salles').add({
        'ville': ville,
        'price': price,
        'surface': surface,
        'description': description,
        'imageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salle ajoutée ! Upload de l'image en cours..."),
          backgroundColor: Colors.green,
        ),
      );

      await _uploadImageAndUpdate(docRef.id);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une Salle"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.purple.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purple, width: 2),
                  ),
                  child:
                      _imageData != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child:
                                kIsWeb
                                    ? Image.memory(
                                      _imageData!,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.memory(
                                      _imageData!,
                                      fit: BoxFit.cover,
                                    ),
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.purple.shade300,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Cliquez pour ajouter une image",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 12),
              if (_isSaving)
                LinearProgressIndicator(
                  value: _uploadProgress,
                  color: Colors.purple,
                ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: ville,
                decoration: const InputDecoration(
                  labelText: "Ville",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city, color: Colors.purple),
                ),
                items:
                    _villes
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                onChanged: (v) => setState(() => ville = v),
                validator: (v) => v == null ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Prix (ex: 1500dt par jour)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.purple),
                ),
                validator:
                    (v) => v == null || v.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => price = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Surface (ex: 300 m²)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten, color: Colors.purple),
                ),
                validator:
                    (v) => v == null || v.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => surface = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description, color: Colors.purple),
                ),
                maxLines: 4,
                validator:
                    (v) => v == null || v.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => description = v,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSalle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            "Ajouter la Salle",
                            style: TextStyle(
                              fontSize: 18,
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
}
