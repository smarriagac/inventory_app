import 'package:flutter/material.dart';
import 'package:rickpan_app/src/bloc/productos_bloc.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final productosBloc = new ProductosBloc();
  String _producto = '';
  String _precio = '';

  @override
  Widget build(BuildContext context) {
    productosBloc.obtenerProducto();
    return Scaffold(
        appBar: AppBar(
          title: Text('Productos'),
        ),
        body: StreamBuilder<List<ProductosModel>>(
          stream: productosBloc.productoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final productoS = snapshot.data;
            if (productoS.length == 0) {
              return Center(child: Text('No hay productos agregados'));
            }
            return Column(
              children: [
                SizedBox(height: 10.0),
                _nombredelProducto(),
                SizedBox(height: 20.0),
                _preciodelProducto(),
                Divider(color: Theme.of(context).primaryColor, height: 20.0),
                _productosAgregados(productoS),
              ],
            );
          },
        ));
  }

  Widget _nombredelProducto() {
    return TextField(
        keyboardType: TextInputType.text,
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
            }));
  }

  Widget _preciodelProducto() {
    return TextField(
        obscureText: true,
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
            }));
  }

  Widget _productosAgregados(List<ProductosModel> productoS) {
    return Flexible(
      child: ListView.builder(
        itemCount: productoS.length,
        itemBuilder: (context, i) => Dismissible(
          key: UniqueKey(),
          background: Container(color: Theme.of(context).primaryColor),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ListTile(
          title: Text(
            productoS[i].producto,
            style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          ),
          subtitle: Text('PRECIO: ${productoS[i].precio}')),
    );
  }
}
