import 'package:flutter/material.dart';
import 'package:rickpan_app/src/models/carrito_model.dart';

import 'package:rickpan_app/src/models/scan_model.dart';
import 'package:rickpan_app/src/bloc/productos_bloc.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';
import 'package:spinner_input/spinner_input.dart';

class PedidoPage extends StatefulWidget {
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final productosBloc = new ProductosBloc();
  List<CarritoModel> _carrito;
  //final _cantidad = new Cantidad();
  int _cantidad = 0;
  double _spinner = 0;
  @override
  Widget build(BuildContext context) {
    productosBloc.obtenerProducto();
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Realizar Pedido'),
        ),
        body: StreamBuilder<List<ProductosModel>>(
          stream: productosBloc.productoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final pedidoS = snapshot.data;
            return Column(
              children: [
                _infodelatienda(scan),
                Divider(color: Theme.of(context).primaryColor, height: 20.0),
                _infoProductos(context, pedidoS),
              ],
            );
          },
        ));
  }

  _infodelatienda(ScanModel scan) {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Align(
        child: Text(
          scan.valor,
          style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        ),
        alignment: Alignment.topLeft,
      ),
    );
  }

  _infoProductos(BuildContext context, List<ProductosModel> pedidoS) {
    if (pedidoS.length == 0) {
      return Center(child: Text('No hay productos agregados'));
    }
    return Flexible(
        child: ListView.builder(
            itemCount: pedidoS.length,
            itemBuilder: (context, i) =>
                _productosPedidos(context, pedidoS, i)));
  }

  _productosPedidos(BuildContext context, List<ProductosModel> pedidoS, int i) {
    List<int> cantidadPedido = List<int>(pedidoS.length);
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        children: [
          _r1(context, pedidoS, i),
          Divider(color: Theme.of(context).primaryColor, height: 20.0),
          _r2(context, pedidoS, i, cantidadPedido),
        ],
      ),
    );
  }

  _r1(BuildContext context, List<ProductosModel> pedidoS, int i) {
    return Expanded(
      child: ListTile(
        title: Text(
          'Producto: ${pedidoS[i].producto}',
          style: TextStyle(fontSize: 19.0, fontStyle: FontStyle.italic),
        ),
        subtitle: Text(
          'Precio: ${pedidoS[i].precio}',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );
  }

  _r2(BuildContext context, List<ProductosModel> pedidoS, int i,
      List<int> cantidadPedido) {
    return Card(
      color: Colors.brown[300],
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Row(
        children: [
          _iconosIncremento(Icons.add_box_rounded, i, cantidadPedido),
          Text(
            _cantidad.toString(),
            style: TextStyle(fontSize: 18.0),
          ),
          _iconoDecremento(Icons.indeterminate_check_box, i, cantidadPedido),
        ],
      ),
    );
  }

  _prueba() {
    return Container(
        margin: EdgeInsets.all(5.0),
        child: SpinnerInput(
          spinnerValue: _spinner,
          onChange: (newValue) {
            setState(() {
              _spinner = newValue;
            });
          },
        ));
  }

  _iconosIncremento(IconData icono, int i, List<int> cantidadPedido) {
    return IconButton(
      icon: Icon(icono),
      iconSize: 25.0,
      onPressed: () {
        setState(() {
          _carrito[i].cantidad++;
          print('Incremento[$i] : ${_carrito[i].cantidad}');
        });
      },
    );
  }

  _iconoDecremento(IconData decremento, int i, List<int> cantidadPedido) {
    return IconButton(
      icon: Icon(decremento),
      iconSize: 25.0,
      onPressed: () {
        setState(() {
          _carrito[i].cantidad--;
          print('Decremento [$i] : ${_carrito[i].cantidad}');
/*           if (_cantidad <= 0) {
            cantidadPedido[i] = 0;
          } */
        });
      },
    );
  }
}
