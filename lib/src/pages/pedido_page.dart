import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rickpan_app/src/models/carrito_model.dart';

import 'package:rickpan_app/src/models/scan_model.dart';
import 'package:rickpan_app/src/bloc/productos_bloc.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_extend/share_extend.dart';
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
              color: Theme.of(context).primaryColor,
              child:
                  Text('Enviar Pedido', style: TextStyle(color: Colors.white)),
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
    var pagina = documento.pages.add();
    var tamanoPagina = pagina.getClientSize();
    //fecha
    var now = DateTime.now();

    // ================ figura rickpan ========================= //
    pagina.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(205, 167, 92, 255)),
        bounds: Rect.fromLTWH(0, 0, tamanoPagina.width - 115, 90));

    pagina.graphics.drawString(
        'RICKPAN', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfSolidBrush(PdfColor(0, 28, 125)),
        bounds: Rect.fromLTWH(25, 0, tamanoPagina.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    pagina.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, tamanoPagina.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(188, 144, 49)));

    // ================= fecha en el pdf =========================//
    pagina.graphics.drawString('${DateFormat("dd/MM/yyyy").format(now)}',
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfBrushes.red, bounds: Rect.fromLTWH(420, 130, 500, 30));

    // ================ datos de la tienda ======================= //
    String datosTienda = scan.valor.toString();
    var layaoutResult = PdfTextElement(
            text: datosTienda,
            font: PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfSolidBrush(PdfColor(0, 28, 125)))
        .draw(
            page: pagina,
            bounds:
                Rect.fromLTWH(0, 100, tamanoPagina.width, tamanoPagina.height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    pagina.graphics.drawLine(
        PdfPen(PdfColor(0, 26, 248)),
        Offset(0, layaoutResult.bounds.bottom + 10),
        Offset(tamanoPagina.width, layaoutResult.bounds.bottom + 10));

    // =========================== TABLA ================================= //
    var grid = PdfGrid();

    grid.columns.add(count: 4);

    var encabezado = grid.headers.add(1)[0];
    encabezado.cells[0].value = 'Producto';
    encabezado.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    encabezado.cells[1].value = 'Precio';
    encabezado.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    encabezado.cells[2].value = 'Cantidad';
    encabezado.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    encabezado.cells[3].value = 'Total';
    encabezado.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    encabezado.style.backgroundBrush = PdfSolidBrush(PdfColor(191, 3, 17));
    encabezado.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    encabezado.style.textBrush = PdfBrushes.white;

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable1LightAccent5);

    for (var i = 0; i < pedidoS.length; i++) {
      agregarListProduct(
          nombproducto: pedidoS[i].producto,
          precio: pedidoS[i].precio,
          cantidad: _nproducto[i].cantidad,
          total: _nproducto[i].cantidad * pedidoS[i].precio,
          grid: grid);
    }

    grid.columns[1].width = 200;
    for (var i = 0; i < encabezado.cells.count; i++) {
      encabezado.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (var i = 0; i < grid.rows.count; i++) {
      var row = grid.rows[i];
      for (var j = 0; j < row.cells.count; j++) {
        var cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.draw(
        page: pagina,
        bounds: Rect.fromLTWH(0, 210, tamanoPagina.width, tamanoPagina.height));

    // ========================= TOTAL  PRINCIPAL =========================== //
    pagina.graphics.drawString(
        'TOTAL \$${getTotalAmount(grid).toStringAsFixed(0)}',
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, tamanoPagina.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    // ==================== TOTAL FINAL ==================================== //

    // =============== guardar informacion en documento =================== //
    var bytes = documento.save();
    documento.dispose();

    // =============== abrir pdf ======================= //
    Directory directorio = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String path = directorio.path;
    File file = File('$path/facturas/Pedido.pdf');
    if (!await file.exists()) {
      await file.create(recursive: true);
      file.writeAsStringSync('Compartir Documento');
    }
    await file.writeAsBytes(bytes, flush: true);
    //OpenFile.open('$path/Pedido.pdf'); // abrir el pdf con app local instalada
    // ================ Compartir archivo guardado ======================== //
    ShareExtend.share(file.path, "Archvo", sharePanelTitle: 'Enviar pedido');
  }

  agregarListProduct(
      {String nombproducto,
      int precio,
      int cantidad,
      int total,
      PdfGrid grid}) {
    var row = grid.rows.add();
    row.cells[0].value = nombproducto.toString();
    row.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[1].value = precio.toString();
    row.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[2].value = cantidad.toString();
    row.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[3].value = total.toString();
    row.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10);
  }

  double getTotalAmount(PdfGrid grid) {
    double totalGe = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 1].value;

      totalGe += double.parse(value);
      //print(value);
    }
    return totalGe;
  }
}
