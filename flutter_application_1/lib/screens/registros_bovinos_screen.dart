// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/bovino.dart';

class RegistrosBovinosScreen extends StatefulWidget {
  const RegistrosBovinosScreen({super.key});

  @override
  State<RegistrosBovinosScreen> createState() => _RegistrosBovinosScreenState();
}

class _RegistrosBovinosScreenState extends State<RegistrosBovinosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroAnimalController = TextEditingController();
  final _pesoController = TextEditingController();
  final _reporteVacunasController = TextEditingController();
  final _observacionesController = TextEditingController();

  String _tipoAnimalSeleccionado = 'Vacas';
  String? _razaSeleccionada;
  String? _enfermedadSeleccionada;
  String? _disposicionSeleccionada;
  File? _imagenSeleccionada;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Listas de opciones para los dropdowns
  final List<String> _tiposAnimal = [
    'Vacas',
    'Novillos',
    'Toros',
    'Terneros/becceros',
  ];

  final List<String> _razas = [
    'Holstein',
    'Angus',
    'Hereford',
    'Brahman',
    'Simmental',
    'Charolais',
    'Limousin',
    'Shorthorn',
    'Otra',
  ];

  final List<String> _enfermedades = [
    'Ninguna',
    'Mastitis',
    'Fiebre aftosa',
    'Brucelosis',
    'Tuberculosis',
    'Parásitos internos',
    'Parásitos externos',
    'Otra',
  ];

  final List<String> _disposiciones = [
    'Reproducción',
    'Venta',
    'Engorde',
    'Leche',
    'Carne',
    'Reemplazo',
    'Otra',
  ];

  Future<void> _seleccionarImagen() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imagenSeleccionada = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<void> _guardarRegistro() async {
    if (_formKey.currentState!.validate()) {
      if (_razaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una raza')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('Usuario no autenticado');
        }

        // Crear el objeto Bovino
        final bovino = Bovino(
          numeroAnimal: _numeroAnimalController.text.trim(),
          tipoAnimal: _tipoAnimalSeleccionado,
          raza: _razaSeleccionada!,
          enfermedad: _enfermedadSeleccionada,
          disposicion: _disposicionSeleccionada,
          peso: _pesoController.text.trim(),
          reporteVacunas: _reporteVacunasController.text.trim(),
          observaciones: _observacionesController.text.trim(),
          fechaRegistro: DateTime.now(),
          usuarioId: user.uid,
        );

        // Guardar en Firestore
        await FirebaseFirestore.instance
            .collection('bovinos')
            .add(bovino.toMap());

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Limpiar formulario y recargar
        _limpiarFormulario();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _limpiarFormulario() {
    _numeroAnimalController.clear();
    _pesoController.clear();
    _reporteVacunasController.clear();
    _observacionesController.clear();
    setState(() {
      _tipoAnimalSeleccionado = 'Vacas';
      _razaSeleccionada = null;
      _enfermedadSeleccionada = null;
      _disposicionSeleccionada = null;
      _imagenSeleccionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32), // Verde oscuro
              Color(0xFF4CAF50), // Verde medio
              Color(0xFFE8F5E8), // Verde muy claro
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con logo y título
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Color(0xFF2E7D32),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Título
                    const Text(
                      'COWAPP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Botón de regreso
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Contenido principal
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de la sección
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Registros bovinos',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Sección de tipo de animal con diseño de pestañas
                          _buildTipoAnimalSection(),

                          const SizedBox(height: 30),

                          // Sección de información del animal
                          _buildAnimalInfoSection(),

                          const SizedBox(height: 30),

                          // Botón de guardar
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _guardarRegistro,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 3,
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        'GUARDAR DATOS',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipoAnimalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección actual
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _tipoAnimalSeleccionado,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Botones de tipo de animal
        Row(
          children:
              _tiposAnimal.map((tipo) {
                final isSelected = _tipoAnimalSeleccionado == tipo;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _tipoAnimalSeleccionado = tipo;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        tipo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnimalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Número del animal con icono +
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextFormField(
                  controller: _numeroAnimalController,
                  decoration: InputDecoration(
                    hintText: 'Nº del animal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el número del animal';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Imagen del animal
          GestureDetector(
            onTap: _seleccionarImagen,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child:
                  _imagenSeleccionada != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          _imagenSeleccionada!,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Toca para tomar foto',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
            ),
          ),

          const SizedBox(height: 20),

          // Campos de información
          _buildInfoField('Raza', _razaSeleccionada, _razas, (value) {
            setState(() {
              _razaSeleccionada = value;
            });
          }, required: true),

          _buildInfoField(
            'Enfermedad',
            _enfermedadSeleccionada,
            _enfermedades,
            (value) {
              setState(() {
                _enfermedadSeleccionada = value;
              });
            },
          ),

          _buildInfoField(
            'Disposición',
            _disposicionSeleccionada,
            _disposiciones,
            (value) {
              setState(() {
                _disposicionSeleccionada = value;
              });
            },
          ),

          _buildTextField('Peso', _pesoController, 'kg'),
          _buildTextField('Reporte de vacunas', _reporteVacunasController, ''),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    String? value,
    List<String> options,
    Function(String?) onChanged, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
              items:
                  options
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
              onChanged: onChanged,
              validator:
                  required
                      ? (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona una $label';
                        }
                        return null;
                      }
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String suffix,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _numeroAnimalController.dispose();
    _pesoController.dispose();
    _reporteVacunasController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
