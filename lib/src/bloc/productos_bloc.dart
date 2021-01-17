import 'dart:async';

import 'package:rickpan_app/src/models/producto_model.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';

class ProductosBloc {
  static final ProductosBloc _singleton = new ProductosBloc._internal();

  factory ProductosBloc() {
    return _singleton;
  }
  ProductosBloc._internal() {
    // obtener los Productos de la Base de datos
    obtenerProducto();
  }

  final _productoController =
      StreamController<List<ProductosModel>>.broadcast();

  Stream<List<ProductosModel>> get productoStream => _productoController.stream;

  dispose() {
    _productoController?.close();
  }

  obtenerProducto() async {
    _productoController.sink.add(await DBprovider.db.getTodosProductos());
  }

  agregarProducto(ProductosModel nuevoProducto) {
    DBprovider.db.nuevoProducto(nuevoProducto);
    obtenerProducto();
  }

  borrarProducto(int id) async {
    await DBprovider.db.deleteProductos(id);
    obtenerProducto();
  }

  borrarTODOS() async {
    await DBprovider.db.deleteAllProductos();
    obtenerProducto();
  }
}
