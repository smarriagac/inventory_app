import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rickpan_app/src/models/carrito_model.dart';

import 'package:rickpan_app/src/models/scan_model.dart';
import 'package:rickpan_app/src/bloc/productos_bloc.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PedidoPage extends StatefulWidget {
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final productosBloc = new ProductosBloc();
  List<CantidadP> _nproducto = List<CantidadP>();
  //final _cantidad = new Cantidad();
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
                SizedBox(width: 5.0),
                _infoTotal(pedidoS, _nproducto, context, scan),
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

  _infoTotal(List<ProductosModel> pedidoS, List<CantidadP> _nproducto,
      BuildContext context, ScanModel scan) {
    double total = 0.0;
    for (var i = 0; i < pedidoS.length; i++) {
      total = total + pedidoS[i].precio * _nproducto[i].cantidad;
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              child: Text('Enviar Pedido'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              onPressed: () => _generarPDF(pedidoS, _nproducto, context, scan),
            ),
          ),
        ),
        Container(
          child: Text(
            'Total:  \$${total.toStringAsFixed(0)}',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          padding: EdgeInsets.all(5.0),
        )
      ],
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
          Divider(color: Theme.of(context).primaryColor, height: 20.0),
          _r3(context, pedidoS, i),
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
        ],
      ),
    );
  }

  _iconosIncremento(IconData icono, int i, List<ProductosModel> pedidoS) {
    return IconButton(
      icon: Icon(icono),
      iconSize: 20.0,
      color: Colors.amber,
      onPressed: () {
        setState(() {
          _nproducto[i].cantidad++;
          //print('Incremento[$i] : ${_nproducto[i].cantidad}');
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
          //print('Decremento [$i] : ${_nproducto[i].cantidad}');
          _nproducto[i].cantidad--;
          if (_nproducto[i].cantidad <= 0) {
            _nproducto[i].cantidad = 0;
          }
        });
      },
    );
  }

  _r3(BuildContext context, List<ProductosModel> pedidoS, int i) {
    return Expanded(
      child: Column(
        children: [
/*           Text('Total',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0), */
          Container(
            child: Text('${_nproducto[i].cantidad * pedidoS[i].precio}',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
            ),
          )
        ],
      ),
    );
  }

  void _canditadProducto() {
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

  Future<void> _generarPDF(List<ProductosModel> pedidoS,
      List<CantidadP> _nproducto, BuildContext context, ScanModel scan) async {
    var documento = PdfDocument();
    documento.pages.add().graphics.drawString(
        'Hola PUTOOOOO', PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfSolidBrush(PdfColor(240, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 30));

    documento.pages.add().graphics.drawString(
        '12/15/2020', PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfSolidBrush(PdfColor(200, 0, 0)),
        bounds: Rect.fromLTWH(100, 0, 500, 30));
    var bytes = documento.save();
    documento.dispose();

    // abrir pdf
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    File file = File('$path/Output.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Output.pdf');
  }
}
