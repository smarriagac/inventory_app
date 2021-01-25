class CantidadP {
  CantidadP({
    this.cantidad = 0,
  });

  int cantidad;

  void incrementarCantidad() {
    this.cantidad = this.cantidad + 1;
  }

  void decrementarCantidad() {
    this.cantidad = this.cantidad - 1;
  }
}
