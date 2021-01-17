class ProductosModel {
  ProductosModel({
    this.idProducto,
    this.producto,
    this.precio,
  });

  int idProducto;
  String producto;
  int precio;

  factory ProductosModel.fromJson(Map<String, dynamic> json) => ProductosModel(
        idProducto: json["idProducto"],
        producto: json["producto"],
        precio: json["precio"],
      );

  Map<String, dynamic> toJson() => {
        "idProducto": idProducto,
        "producto": producto,
        "precio": precio,
      };
}
