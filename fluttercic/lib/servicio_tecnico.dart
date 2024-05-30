import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttercic/API_service.dart';
import 'package:fluttercic/solicitud_model.dart';

class Solicitud extends StatefulWidget {
  final APIService apiService;

  Solicitud({required this.apiService});

  @override
  _SolicitudState createState() => _SolicitudState();
}

class _SolicitudState extends State<Solicitud> {
  final APIService apiService = APIService(baseUrl: 'http://10.0.2.2:3004'); //Esta es la IP del emulador y el puerto de la API

  static final Map<String, int> edificioNivelToId = {
    'A 1': 1,
    'A 2': 2,
    'A 3': 3,
    'B 1': 4,
    'B 2': 5,
    'B 3': 6,
    'C 1': 7,
    'C 2': 8,
    'C 3': 9,
    'D 1': 10,
    'D 2': 11,
    'D 3': 12,
    'E 1': 13,
    'E 2': 14,
    'E 3': 15,
    'F 1': 16,
    'F 2': 17,
    'F 3': 18,
    'G 1': 19,
    'G 2': 20,
    'G 3': 21,
    'H 1': 22,
    'H 2': 23,
    'H 3': 24,
    'I 1': 25,
    'I 2': 26,
    'I 3': 27,
    'J 1': 28,
    'K 1': 29,
    'Coordinación 1': 30,
    'CIC 1': 31,
    'I+D+I 1': 32,
    'I+D+I 2': 33,
    'I+D+I 3': 34,
  };

  final List<String> edificios = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'Coordinación', 'CIC', 'I+D+I'];

  String edificioSeleccionado = 'A'; // Valor predeterminado para el edificio seleccionado
  List<String> niveles = ['1', '2', '3'];

  String nivelSeleccionado = '1'; // Valor predeterminado para el nivel seleccionado

  bool isNivelBloqueado() {
    return ['CIC', 'Coordinación', 'J', 'K'].contains(edificioSeleccionado);
  }

  static int obtenerIdEdificio(String edificioSeleccionadoParam, String nivelSeleccionado) {
    final key = '$edificioSeleccionadoParam $nivelSeleccionado';
    final edificioSeleccionado = edificioNivelToId[key];
    if (edificioSeleccionado == null) {
      throw Exception('No se encontró el ID de edificio para $key');
    }
    return edificioSeleccionado;
  }

  TextEditingController telefonoController = TextEditingController();
  TextEditingController ubicacionFisicaController = TextEditingController();
  TextEditingController otroEspecifiqueController = TextEditingController();
  TextEditingController descripcionProblemaController = TextEditingController();

  String ubicacionFisica = '';
  String telefono = '';
  List<String> equiposSeleccionados = [];
  String otroEspecifique = '';
  String descripcionProblema = '';

  void _mostrarVentanaConfirmacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Estás seguro de enviar la solicitud?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
  child: Text("Aceptar"),
  onPressed: () async {
    if (_validarDatos()) {
      // Ya se maneja en _seleccionarEquipos

      SolicitudModel solicitud = SolicitudModel(
        description: descripcionProblema,
        type: equiposSeleccionados.join(', '), // Combina equipos seleccionados
        telefono: telefono,
        idEdificio: obtenerIdEdificio(edificioSeleccionado, nivelSeleccionado), // Aquí se llama al método obtenerIdEdificio,
        ubicacionFisica: ubicacionFisica,
        equipo: equiposSeleccionados.join(', '),
      );

      try {
        final sessionToken = await _getSessionToken();
        print('Token de sesión: $sessionToken');
        await apiService.createSolicitud(solicitud);

        // Limpiar los campos
        setState(() {
            telefonoController.clear();
            ubicacionFisicaController.clear();
            otroEspecifiqueController.clear();
            descripcionProblemaController.clear();
            ubicacionFisica = '';
            telefono = '';
            equiposSeleccionados = [];
            otroEspecifique = '';
            descripcionProblema = '';
          });
        Navigator.of(context).pop(); // Cerrar la ventana de confirmación
        _mostrarSolicitudEnviada(context); // Mostrar ventana de solicitud enviada
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar la solicitud: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios.'),
        ),
      );
    }
  },
),
          ],
        );
      },
    );
  }

  Future<String> _getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('sessionToken');

    if (sessionToken != null) {
      return sessionToken;
    } else {
      throw Exception('No se encontró un token de sesión almacenado.');
    }
  }

  void _mostrarSolicitudEnviada(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Solicitud Enviada"),
          content: Text("Tu solicitud ha sido enviada con éxito."),
          actions: <Widget>[
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _validarDatos() {
    return telefono.isNotEmpty &&
        ubicacionFisica.isNotEmpty &&
        descripcionProblema.isNotEmpty;
  }

  // Método para seleccionar equipos (simulado)
void _seleccionarEquipos() async {
  final List<String> equipos = ['Monitor', 'PC', 'Gabinete', 'Nodo', 'UPS', 'Teclado', 'Laptop', 'Mouse', 'Proyector', 'Teléfono', 'Acces Point', 'Impresora', 'Otro'];
  final Map<String, dynamic> resultado = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(equipos: equipos, seleccionados: equiposSeleccionados, otroEspecifiqueController: otroEspecifiqueController);
    },
  ) ?? {'seleccionados': [], 'otroEspecifique': ''};

  setState(() {
    equiposSeleccionados = List<String>.from(resultado['seleccionados']);
    otroEspecifique = resultado['otroEspecifique'];

    // Remover "Otro" si se especificó un valor en otroEspecifique
    if (equiposSeleccionados.contains('Otro') && otroEspecifique.isNotEmpty) {
      equiposSeleccionados.remove('Otro');
    }
    // Agregar otroEspecifique solo si no está vacío y no está ya en la lista
    if (otroEspecifique.isNotEmpty && !equiposSeleccionados.contains(otroEspecifique)) {
      equiposSeleccionados.add(otroEspecifique);
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 56,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Solicitud servicio técnico',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xFF022049),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Color(0xFFF0F0F0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(7.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Teléfono: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: telefonoController,
                          onChanged: (value) {
                            setState(() {
                              telefono = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Escribe tu teléfono',
                          ),
                        ),
                        SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Edificio: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: edificioSeleccionado,
                          onChanged: (value) {
                            setState(() {
                              edificioSeleccionado = value!;
                              if (isNivelBloqueado()) {
                                nivelSeleccionado = '1';
                              }
                            });
                          },
                          items: edificios.map((String edificio) {
                            return DropdownMenuItem<String>(
                              value: edificio,
                              child: Text(edificio),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            hintText: 'Selecciona el edificio',
                          ),
                        ),
                        SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nivel: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: nivelSeleccionado,
                          onChanged: isNivelBloqueado()
                              ? null
                              : (value) {
                                  setState(() {
                                    nivelSeleccionado = value!;
                                  });
                                },
                          items: niveles.map((String nivel) {
                            return DropdownMenuItem<String>(
                              value: nivel,
                              child: Text(nivel),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            hintText: 'Selecciona el nivel',
                          ),
                        ),
                        SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Ubicación física: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: ubicacionFisicaController,
                          onChanged: (value) {
                            setState(() {
                              ubicacionFisica = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Escribe tu ubicación física',
                          ),
                        ),
                        SizedBox(height: 33),
                        Text(
                          'Equipo: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _seleccionarEquipos,
                          child: Text('Seleccionar equipos'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Equipos seleccionados: ${equiposSeleccionados.join(', ')}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Descripción del problema: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: descripcionProblemaController,
                          onChanged: (value) {
                            setState(() {
                              descripcionProblema = value;
                            });
                          },
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Describe el problema',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 33),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _mostrarVentanaConfirmacion(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Color(0xFF022049),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text('Enviar Solicitud'),
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
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> equipos;
  final List<String> seleccionados;
  final TextEditingController otroEspecifiqueController;

  MultiSelectDialog({required this.equipos, required this.seleccionados, required this.otroEspecifiqueController});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<String> _tempSeleccionados = [];
  bool _otroSeleccionado = false;

  @override
  void initState() {
    _tempSeleccionados = widget.seleccionados;
    _otroSeleccionado = _tempSeleccionados.contains('Otro');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Seleccionar Equipos'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListBody(
              children: widget.equipos.map((equipo) {
                return CheckboxListTile(
                  value: _tempSeleccionados.contains(equipo),
                  title: Text(equipo),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _tempSeleccionados.add(equipo);
                        if (equipo == 'Otro') {
                          _otroSeleccionado = true;
                        }
                      } else {
                        _tempSeleccionados.remove(equipo);
                        if (equipo == 'Otro') {
                          _otroSeleccionado = false;
                          widget.otroEspecifiqueController.clear();
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_otroSeleccionado)
              TextField(
                controller: widget.otroEspecifiqueController,
                decoration: InputDecoration(
                  hintText: 'Especifica el otro equipo',
                ),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop({'seleccionados': _tempSeleccionados, 'otroEspecifique': widget.otroEspecifiqueController.text});
          },
        ),
      ],
    );
  }
}
