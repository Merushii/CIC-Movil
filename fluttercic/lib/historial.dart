import 'package:flutter/material.dart';
import 'package:fluttercic/API_service.dart';
import 'package:fluttercic/solicitud_model.dart';

class Historial extends StatelessWidget {
  final APIService apiService;

  Historial({required this.apiService});

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
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Historial de solicitudes',
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
      body: FutureBuilder<List<SolicitudModel>>(
        future: apiService.obtenerHistorialSolicitudes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el historial'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay solicitudes en el historial'));
          } else {
            final solicitudes = snapshot.data!;
            return ListView.builder(
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = solicitudes[index];
                Color tileColor;
                switch (solicitud.estado) {
                  case 'Abierto':
                    tileColor = Colors.red[100]!;
                    break;
                  case 'Proceso':
                    tileColor = Colors.blue[100]!;
                    break;
                  case 'Espera':
                    tileColor = Colors.lightBlue[100]!;
                    break;
                  case 'Cerrado':
                    tileColor = Colors.green[100]!;
                    break;
                  case 'Asignada':
                    tileColor = Colors.yellow[100]!;
                    break;
                  default:
                    tileColor = Colors.white;
                }
                return Card(
                  child: ListTile(
                    title: Text('Folio de reporte: ${solicitud.folioSolicitud}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha: ${solicitud.fecha}'),
                        Text('Equipo: ${solicitud.equipo}'),
                        Text('Estado de reporte: ${solicitud.estado}'),
                        Text('Descripción: ${solicitud.description}'),
                        // Aquí puedes agregar más detalles de la solicitud si es necesario
                      ],
                    ),
                    tileColor: tileColor,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
