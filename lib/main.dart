import 'package:flutter/material.dart';
import 'services/thingspeak_service.dart'; // Importa el servicio
import 'dart:async';

void main() {
  runApp(const MiAppThingSpeak());
}

class MiAppThingSpeak extends StatelessWidget {
  const MiAppThingSpeak({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor Cardiaco ThingSpeak',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Monitor Cardiaco'),
        ),
        body: const CentroDeDatos(),
      ),
    );
  }
}

class CentroDeDatos extends StatefulWidget {
  const CentroDeDatos({super.key});

  @override
  _CentroDeDatosState createState() => _CentroDeDatosState();
}

class _CentroDeDatosState extends State<CentroDeDatos> {
  final String readApiKey = '2Z9QX5SYU33HVCHZ'; // Reemplaza con tu Read API Key
  Timer? timer;
  int? bpmActual; // Valor actual de BPM
  bool mostrarValorReal = true; // Bandera para alternar el valor mostrado

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => obtenerDatos());
    obtenerDatos();
  }

  void obtenerDatos() async {
    try {
      int nuevoBpm = await obtenerRitmoCardiacoDeThingSpeak(readApiKey);
      setState(() {
        bpmActual = nuevoBpm;
      });
    } catch (e) {
      // Aquí puedes manejar cualquier error que ocurra durante la solicitud
      print('Error al obtener los datos: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<int>(
            future: obtenerRitmoCardiacoDeThingSpeak(readApiKey),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Actualiza el valor de BPM actual
                bpmActual = snapshot.data;
                // Muestra el valor actual de BPM o 0, dependiendo del estado de mostrarValorReal
                return Text('Ritmo Cardiaco: ${mostrarValorReal ? bpmActual : 0} BPM', style: const TextStyle(fontSize: 24));
              }
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                mostrarValorReal = !mostrarValorReal;
              });
            },
            child: Container(
              width: 200, // Define un tamaño para el área tocable
              height: 50,
              color: Colors.transparent, // Hace el contenedor completamente transparente
            ),
          ),
        ],
      ),
    );
  }
}
