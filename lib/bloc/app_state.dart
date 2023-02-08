abstract class AppStates{}

class InitialState extends AppStates{}

class LoadingLoginScreen extends AppStates{}
class SuccessLoginScreen extends AppStates{}
class ErrorLoginScreen extends AppStates{
  final String error;
  ErrorLoginScreen(this.error);
}

class ChangeCheckBox extends AppStates{}

class LoadingSignUpScreen extends AppStates{}
class SuccessSignUpScreen extends AppStates{}
class ErrorSignUpScreen extends AppStates{
  final String error;
  ErrorSignUpScreen(this.error);
}
class VisiblePasswordSignUp extends AppStates{}

class LoadingGetDataUser extends AppStates{}
class SuccessGetDataUser extends AppStates{}
class ErrorGetDataUser extends AppStates{
  final String error;
  ErrorGetDataUser(this.error);
}

class LoadingAddProduct extends AppStates{}
class SuccessAddProduct extends AppStates{}
class ErrorAddProduct extends AppStates{
  final String error;
  ErrorAddProduct(this.error);
}

class LoadingGetProducts extends AppStates{}
class SuccessGetProducts extends AppStates{}
class ErrorGetProducts extends AppStates{
  final String error;
  ErrorGetProducts(this.error);
}

class LoadingGetProductsHideUser extends AppStates{}
class SuccessGetProductsHideUser extends AppStates{}
class ErrorGetProductsHideUser extends AppStates{
  final String error;
  ErrorGetProductsHideUser(this.error);
}

class LoadingDeleteProduct extends AppStates{}
class SuccessDeleteProduct extends AppStates{}
class ErrorDeleteProduct extends AppStates{
  final String error;
  ErrorDeleteProduct(this.error);
}

class LoadingUpdateProduct extends AppStates{}
class SuccessUpdateProduct extends AppStates{}
class ErrorUpdateProduct extends AppStates{
  final String error;
  ErrorUpdateProduct(this.error);
}

class LoadingAddFolder extends AppStates{}
class SuccessAddFolder extends AppStates{}
class ErrorAddFolder extends AppStates{
  final String error;
  ErrorAddFolder(this.error);
}

class LoadingGetFolders extends AppStates{}
class SuccessGetFolders extends AppStates{}
class ErrorGetFolders extends AppStates{
  final String error;
  ErrorGetFolders(this.error);
}

class LoadingDeleteFolder extends AppStates{}
class SuccessDeleteFolder extends AppStates{}
class ErrorDeleteFolder extends AppStates{
  final String error;
  ErrorDeleteFolder(this.error);
}

class LoadingAddOrder extends AppStates{}
class SuccessAddOrder extends AppStates{}
class ErrorAddOrder extends AppStates{
  final String error;
  ErrorAddOrder(this.error);
}

class LoadingGetOrdersUser extends AppStates{}
class SuccessGetOrdersUser extends AppStates{}
class ErrorGetOrdersUser extends AppStates{
  final String error;
  ErrorGetOrdersUser(this.error);
}

class LoadingGetOrdersAdmin extends AppStates{}
class SuccessGetOrdersAdmin extends AppStates{}
class ErrorGetOrdersAdmin extends AppStates{
  final String error;
  ErrorGetOrdersAdmin(this.error);
}

class SignOutState extends AppStates{}
class ChangeImageState extends AppStates{}
class GetSearchProduct extends AppStates{}
class ChangeQRCode extends AppStates{}
class ChangeTypeAccount extends AppStates{}

class SuccessConfirmTwoState extends AppStates{}
class ErrorConfirmTwoState extends AppStates{}

class SuccessConfirmThreeState extends AppStates{}
class ErrorConfirmThreeState extends AppStates{}