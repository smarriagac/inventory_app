import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Column(
          children: [
            _logo(),
            _titulo(),
            _descipcion(),
            _creadores(),
          ],
        ),
      ),
    );
  }

  _logo() => Container(
        margin: EdgeInsets.all(10.0),
        child: Image.asset('assets/info.jpg'),
      );

  _titulo() => Flexible(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'APLICACIÓN DE INVENTARIO RICKPAN',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _descipcion() {
    String texto =
        'Esta aplicación gestiona el proceso de recolección de pedidos '
        'que se realizan de forma manual mediante las facturas. '
        'Esta aplicacón se creo con la finalidad de optar por el titulo de ingeniero electronico';
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        texto,
        style: TextStyle(fontSize: 20.0),
        textAlign: TextAlign.justify,
      ),
    );
  }

  _creadores() {
    String creador = 'Diseñada por:\nJEAN CARLOS SOLTO CALDERON\n'
        'ELIAS ITURRIAGO\n'
        'Director:\nJOSE LUIS CONSUEGRA';

    return Flexible(
      child: Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.all(5.0),
        child: Text(
          creador,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
