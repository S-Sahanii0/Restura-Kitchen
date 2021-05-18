class Order {
  final int id;
  final String customer;
  final String item;
  final int quantity;
  final DateTime time;
  final bool status;

  Order(this.id, this.customer, this.item, this.quantity, this.time,
      this.status);

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "customer": this.customer,
      "item": this.item,
      "quantity": this.quantity,
      "time": this.time.toIso8601String(),
      "status": this.status,
    };
  }
}
