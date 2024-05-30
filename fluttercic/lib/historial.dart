import 'package:flutter/material.dart';
import 'package:fluttercic/API_service.dart';
import 'package:fluttercic/solicitud_model.dart';
import 'package:intl/intl.dart';

class Historial extends StatefulWidget {
  final APIService apiService;

  Historial({required this.apiService});

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  String filtroSeleccionado = 'Todos';
  List<SolicitudModel> solicitudesFiltradas = [];
  List<SolicitudModel> todasSolicitudes = [];

  @override
  void initState() {
    super.initState();
    widget.apiService.obtenerHistorialSolicitudes().then((solicitudes) {
      setState(() {
        todasSolicitudes = solicitudes;
        solicitudesFiltradas = filtrarSolicitudes(filtroSeleccionado, todasSolicitudes);
      });
    });
  }

  List<SolicitudModel> filtrarSolicitudes(String filtro, List<SolicitudModel> solicitudes) {
    final ahora = DateTime.now();
    switch (filtro) {
      case 'Hoy':
        return solicitudes.where((solicitud) {
          if (solicitud.fecha == null) return false;
          final fechaSolicitud = DateFormat('yyyy-MM-dd').parse(solicitud.fecha!);
          return fechaSolicitud.year == ahora.year &&
              fechaSolicitud.month == ahora.month &&
              fechaSolicitud.day == ahora.day;
        }).toList();
      case 'Esta Semana':
        return solicitudes.where((solicitud) {
          if (solicitud.fecha == null) return false;
          final fechaSolicitud = DateFormat('yyyy-MM-dd').parse(solicitud.fecha!);
          final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
          return fechaSolicitud.isAfter(inicioSemana.subtract(Duration(days: 1))) &&
              fechaSolicitud.isBefore(inicioSemana.add(Duration(days: 7)));
        }).toList();
      case 'Este Mes':
        return solicitudes.where((solicitud) {
          if (solicitud.fecha == null) return false;
          final fechaSolicitud = DateFormat('yyyy-MM-dd').parse(solicitud.fecha!);
          return fechaSolicitud.year == ahora.year && fechaSolicitud.month == ahora.month;
        }).toList();
      default:
        return solicitudes;
    }
  }

  void actualizarFiltro(String filtro) {
    setState(() {
      filtroSeleccionado = filtro;
      solicitudesFiltradas = filtrarSolicitudes(filtroSeleccionado, todasSolicitudes);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => actualizarFiltro('Hoy'),
                  child: Text('Hoy'),
                ),
                ElevatedButton(
                  onPressed: () => actualizarFiltro('Esta Semana'),
                  child: Text('Esta Semana'),
                ),
                ElevatedButton(
                  onPressed: () => actualizarFiltro('Este Mes'),
                  child: Text('Este Mes'),
                ),
                ElevatedButton(
                  onPressed: () => actualizarFiltro('Todos'),
                  child: Text('Todos'),
                ),
              ],
            ),
          ),
          Expanded(
            child: solicitudesFiltradas.isEmpty
                ? Center(child: Text('No hay solicitudes en el historial'))
                : ListView.builder(
                    itemCount: solicitudesFiltradas.length,
                    itemBuilder: (context, index) {
                      final solicitud = solicitudesFiltradas[index];
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
                              Text('Fecha: ${solicitud.fecha ?? "No disponible"}'),
                              Text('Equipo: ${solicitud.equipo}'),
                              Text('Estado de reporte: ${solicitud.estado}'),
                              Text('Descripción: ${solicitud.description}'),
                            ],
                          ),
                          tileColor: tileColor,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}