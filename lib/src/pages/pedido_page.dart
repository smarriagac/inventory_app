import 'package:flutter/material.dart';

import 'package:rickpan_app/src/models/scan_model.dart';
import 'package:rickpan_app/src/bloc/productos_bloc.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';

class PedidoPage extends StatefulWidget {
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final productosBloc = new ProductosBloc();
  //final _cantidad = new Cantidad();
  int _cantidad = 0;
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
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        children: [
          _r1(context, pedidoS, i),
          Divider(color: Theme.of(context).primaryColor, height: 20.0),
          _r2(context, pedidoS, i),
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

  _r2(BuildContext context, List<ProductosModel> pedidoS, int i) {
    return Row(
      children: [
        _iconosIncremento(Icons.add_box, i),
        Text(
          _cantidad.toString(),
          style: TextStyle(fontSize: 18.0),
        ),
        _iconoDecremento(Icons.indeterminate_check_box, i),
      ],
    );
  }

  _iconosIncremento(IconData icono, int i) {
    return IconButton(
      icon: Icon(icono),
      iconSize: 30.0,
      onPressed: () {
        setState(() {
          _cantidad++;
        });
      },
    );
  }

  _iconoDecremento(IconData decremento, int i) {
    return IconButton(
      icon: Icon(decremento),
      iconSize: 30.0,
      onPressed: () {
        setState(() {
          _cantidad--;
          if (_cantidad <= 0) {
            _cantidad = 0;
          }
        });
      },
    );
  }
}
