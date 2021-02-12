import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cart/flutter_cart.dart';
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
  List<CantidadP> _nproducto = List<CantidadP>();
  //final _cantidad = new Cantidad();
  double _spinner = 0;
  List<ProductosModel> pedidoS;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _canditadProducto();
  }

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
        child: Text(scan.valor,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
            itemBuilder: (context, i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    pedidoS.removeAt(i);
                    _nproducto.removeAt(i);
                    print('numero de lista: ${pedidoS.length}');
                    print('numero de producto: ${_nproducto.length}');
                  },
                  child: _productosPedidos(context, pedidoS, i),
                )));
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
          title: Text('${pedidoS[i].producto}',
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          subtitle:
              Text('${pedidoS[i].precio}', style: TextStyle(fontSize: 17.0))),
    );
  }

  _r2(BuildContext context, List<ProductosModel> pedidoS, int i) {
    return Card(
      color: Colors.brown[500],
      semanticContainer: true,
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      child: Row(
        children: [
          _iconoDecremento(Icons.remove, i, pedidoS),
          Text('${_nproducto[i].cantidad}',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          _iconosIncremento(Icons.add, i, pedidoS),

          // _prueba(),
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

  _iconosIncremento(IconData icono, int i, List<ProductosModel> pedidoS) {
    return IconButton(
      icon: Icon(icono),
      iconSize: 20.0,
      color: Colors.amber,
      onPressed: () {
        setState(() {
          _nproducto[i].cantidad++;
          print('Incremento[$i] : ${_nproducto[i].cantidad}');
          print('Precio[$i] : ${_nproducto[i].cantidad * pedidoS[i].precio}');
        });
      },
    );
  }

  _iconoDecremento(IconData decremento, int i, List<ProductosModel> pedidoS) {
    return IconButton(
      icon: Icon(decremento),
      color: Colors.amber,
      iconSize: 20.0,
      onPressed: () {
        setState(() {
          print('Decremento [$i] : ${_nproducto[i].cantidad}');
          print('Precio[$i] : ${_nproducto[i].cantidad * pedidoS[i].precio}');
          _nproducto[i].cantidad--;
          if (_nproducto[i].cantidad <= 0) {
            _nproducto[i].cantidad = 0;
          }
        });
      },
    );
  }

  void _canditadProducto() {
/*     for (var i = 0; i < pedidoS.length; i++) {
      var list = <CantidadP>[];
    } */
    var list = <CantidadP>[
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
      CantidadP(cantidad: 0),
    ];

    setState(() {
      _nproducto = list;
    });
  }
}
