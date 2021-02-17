import 'package:flutter/material.dart';

import 'package:rickpan_app/src/bloc/productos_bloc.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';
import 'package:rickpan_app/src/utils/utils.dart' as util;

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final productosBloc = new ProductosBloc();
  String _producto = '';
  String _precio = '';
  TextEditingController _controller;
  TextEditingController _controller2;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    _controller2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productosBloc.obtenerProducto();
    return Scaffold(
        appBar: AppBar(
          title: Text('Productos',
              style: TextStyle(color: Color.fromRGBO(0, 29, 125, 50.0))),
          actions: [
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: productosBloc.borrarTODOS,
                color: Color.fromRGBO(191, 3, 17, 1.0))
          ],
        ),
        body: StreamBuilder<List<ProductosModel>>(
          stream: productosBloc.productoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final productoS = snapshot.data;

/*             if (productoS.length == 0) {
              return Center(child: Text('No hay productos agregados'));
            } */
            return Column(
              children: [
                SizedBox(height: 10.0),
                _nombredelProducto(),
                SizedBox(height: 10.0),
                _preciodelProducto(),
                SizedBox(height: 5.0),
                _botonAgregarProducto(),
                Divider(color: Theme.of(context).primaryColor, height: 5.0),
                _productosAgregados(productoS),
              ],
            );
          },
        ));
  }

  Widget _nombredelProducto() {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: TextField(
          keyboardType: TextInputType.text,
          controller: _controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Nombre del producto',
              labelText: 'Producto',
              suffixIcon: Icon(Icons.format_list_bulleted),
              icon: Icon(Icons.account_balance)),
          onChanged: (valor) => setState(() {
                _producto = valor;
              })),
    );
  }

  Widget _preciodelProducto() {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: TextField(
          keyboardType: TextInputType.number,
          controller: _controller2,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Precio del producto',
              labelText: 'Precio',
              suffixIcon: Icon(Icons.monetization_on),
              icon: Icon(Icons.money)),
          onChanged: (valor) => setState(() {
                _precio = valor;
              })),
    );
  }

  Widget _botonAgregarProducto() {
    return Container(
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.centerRight,
      child: RaisedButton(
        elevation: 20.0,
        color: Theme.of(context).primaryColor,
        child: Text('Agregar producto'),
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: _validaciondeDatos,
      ),
    );
  }

  _validaciondeDatos() {
    int procioInt = int.parse(_precio);
    if (_producto.isNotEmpty && _precio.isNotEmpty) {
/*       print(_producto);
      print(procioInt); */
      final addproducto =
          ProductosModel(producto: _producto, precio: procioInt);
      productosBloc.agregarProducto(addproducto);
      _controller.clear();
      _controller2.clear();
    }
  }

  Widget _productosAgregados(List<ProductosModel> productoS) {
    if (productoS.length == 0) {
      return Center(child: Text('No hay productos agregados'));
    }
    return Flexible(
      child: ListView.builder(
        itemCount: productoS.length,
        itemBuilder: (context, i) => Dismissible(
          key: UniqueKey(),
          background: Container(
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.centerRight,
            color: Theme.of(context).primaryColor,
            child: IconButton(
              icon: Icon(Icons.delete_forever, size: 40.0),
              color: Color.fromRGBO(0, 29, 125, 50.0),
              onPressed: () => null,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) =>
              productosBloc.borrarProducto(productoS[i].idProducto),
          child: _infoProducto(context, productoS, i),
        ),
      ),
    );
  }

  _infoProducto(BuildContext context, List<ProductosModel> productoS, int i) {
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
          leading: Image.asset('assets/cookies.png'),
          title: Text(
            productoS[i].producto,
            style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          ),
          subtitle: Text('Precio: ${productoS[i].precio}')),
    );
  }
}
