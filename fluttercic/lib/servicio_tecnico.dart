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

  final List<String> niveles = ['1', '2', '3'];

  String nivelSeleccionado = '1'; // Valor predeterminado para el edificio seleccionado

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
 // String edificioYNivel = '';
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
                      //edificioYNivel = '';
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
        //edificioYNivel.isNotEmpty &&
        ubicacionFisica.isNotEmpty &&
        descripcionProblema.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 56,
        //automaticallyImplyLeading: false,
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
                            text: 'Edificio: ', // Cambia el texto a "Edificio: "
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '*', // Marca como campo obligatorio
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
                    DropdownButton<String>(
                      value: edificioSeleccionado,
                      onChanged: (String? newValue) {
                        setState(() {
                          edificioSeleccionado = newValue!;
                        });
                      },
                      items: edificios.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nivel: ', // Cambia el texto a "Nivel: "
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '*', // Marca como campo obligatorio
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
                        DropdownButton<String>(
                          value: nivelSeleccionado,
                          onChanged: (String? newValue) {
                            setState(() {
                              nivelSeleccionado = newValue!;
                            });
                          },
                          items: niveles.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Ubicación Física: ',
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
                            hintText: 'Escribe tu área',
                          ),
                        ),
                        SizedBox(height: 33),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Equipos: ',
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    title: Text('Monitor'),
                                    value: equiposSeleccionados.contains('Monitor'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Monitor');
                                        } else {
                                          equiposSeleccionados.remove('Monitor');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Nodo'),
                                    value: equiposSeleccionados.contains('Nodo'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Nodo');
                                        } else {
                                          equiposSeleccionados.remove('Nodo');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('UPS'),
                                    value: equiposSeleccionados.contains('UPS'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('UPS');
                                        } else {
                                          equiposSeleccionados.remove('UPS');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Laptop'),
                                    value: equiposSeleccionados.contains('Laptop'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Laptop');
                                        } else {
                                          equiposSeleccionados.remove('Laptop');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Proyector'),
                                    value: equiposSeleccionados.contains('Proyector'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Proyector');
                                        } else {
                                          equiposSeleccionados.remove('Proyector');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Access Point'),
                                    value: equiposSeleccionados.contains('Access Point'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Access Point');
                                        } else {
                                          equiposSeleccionados.remove('Access Point');
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    title: Text('PC'),
                                    value: equiposSeleccionados.contains('PC'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('PC');
                                        } else {
                                          equiposSeleccionados.remove('PC');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Gabinete'),
                                    value: equiposSeleccionados.contains('Gabinete'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Gabinete');
                                        } else {
                                          equiposSeleccionados.remove('Gabinete');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Teclado'),
                                    value: equiposSeleccionados.contains('Teclado'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Teclado');
                                        } else {
                                          equiposSeleccionados.remove('Teclado');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Mouse'),
                                    value: equiposSeleccionados.contains('Mouse'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Mouse');
                                        } else {
                                          equiposSeleccionados.remove('Mouse');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Teléfono'),
                                    value: equiposSeleccionados.contains('Teléfono'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Teléfono');
                                        } else {
                                          equiposSeleccionados.remove('Teléfono');
                                        }
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text('Impresora'),
                                    value: equiposSeleccionados.contains('Impresora'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Impresora');
                                        } else {
                                          equiposSeleccionados.remove('Impresora');
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    title: Text('Otro'),
                                    value: equiposSeleccionados.contains('Otro'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value) {
                                          equiposSeleccionados.add('Otro');
                                        } else {
                                          equiposSeleccionados.remove('Otro');
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Visibility(
                          visible: equiposSeleccionados.contains('Otro'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Especifique:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: otroEspecifiqueController,
                                onChanged: (value) {
                                  setState(() {
                                    otroEspecifique = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Especifique',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
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
                        TextField(
                          controller: descripcionProblemaController,
                          onChanged: (value) {
                            setState(() {
                              descripcionProblema = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Escribe todos los detalles de tu problema',
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: Container(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _mostrarVentanaConfirmacion(context);
                              },
                              child: Text(
                                'Enviar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFBA834),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
