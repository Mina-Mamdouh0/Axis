
class OrderModel{
  final String nameProduct;
  final String idOrder;
  final String idProduct;
  final String idUser;
  final String nameUser;
  final String idAdminCreatedProduct;
  final String urlImageProduct;
  final String quantityProduct;
  final String massageOrder;
  final bool confirmOne;
  final bool confirmTwo;
  final bool confirmThree;
  final String createAt;

  factory OrderModel.formJson(Map<String, dynamic> json,){
    return OrderModel(
      nameProduct: json['NameProduct'],
        idOrder: json['IdOrder'],
        idProduct: json['IdProduct'],
        idUser:json['IdUser'],
        urlImageProduct: json['UrlImageProduct'],
        quantityProduct: json['QuantityProduct'],
        idAdminCreatedProduct: json['IdAdminCreatedProduct'],
        confirmOne: json['ConfirmOne'],
        confirmTwo: json['ConfirmTwo'],
        confirmThree: json['ConfirmThree'],
        createAt:json['CreateAt'],
        massageOrder:json['MassageOrder'],
        nameUser:json['NameUser'],
    );
  }

  OrderModel(
      {required this.nameProduct,
      required this.idOrder,
      required this.massageOrder,
      required this.idProduct,
      required this.idUser,
      required this.urlImageProduct,
      required this.quantityProduct,
      required this.confirmOne,
      required this.nameUser,
      required this.confirmTwo,
      required this.confirmThree,
      required this.idAdminCreatedProduct,
      required this.createAt});



  Map<String,dynamic> toMap(){
    return {
      'NameProduct': nameProduct,
      'IdUser':idUser,
      'IdOrder': idOrder,
      'CreateAt':createAt,
      'IdProduct':idProduct,
      'UrlImageProduct':urlImageProduct,
      'QuantityProduct':quantityProduct,
      'IdAdminCreatedProduct':idAdminCreatedProduct,
      'ConfirmOne':confirmOne,
      'ConfirmTwo':confirmTwo,
      'ConfirmThree':confirmThree,
      'MassageOrder':massageOrder,
      'NameUser':nameUser,
    };

  }
}