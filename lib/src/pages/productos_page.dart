import 'package:flutter/material.dart';

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  String _producto = '';
  String _precio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
          _nombredelProducto(),
          SizedBox(height: 20.0),
          _preciodelProducto(),
          Divider(color: Theme.of(context).primaryColor, height: 20.0),
          _productosAgregados(),
        ],
      ),
    );
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

  Widget _productosAgregados() {
    return Flexible(
      child: ListView(
        children: [
          Card(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: ListTile(
                title: Text('Precio del producto'), subtitle: Text('230450')),
          ),
        ],
      ),
    );
  }
}
