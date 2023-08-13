
abstract class Links {

  //usuario

  static const String LOGIN = "usuarios/login/";
  static const String REGISTER = "usuarios/adicionar/";
  static const String UPDATE_USER_DATA = "usuarios/atualizar/";
  static const String LOAD_PROFILE = "usuarios/listar/";
  static const String UPDATE_AVATAR = "usuarios/atualizar_avatar/";
  static const String UPDATE_PASSWORD = "usuarios/atualizar_senha/";
  static const String DISABLE_ACCOUNT = "usuarios/desativarconta/";
  static const String SAVE_FCM = "usuarios/adicionar_fcm/";
  static const String LIST_NOTIFICATIONS = "notificacoes/listar/";
  static const String RECOVER_PASSWORD_TOKEN = "usuarios/recuperar_senha/";
  static const String VERIFY_PASSWORD_TOKEN = "usuarios/verifica_token/";
  static const String UPDATE_PASSWORD_TOKEN = "usuarios/update_password_token/";

  //produtos

  static const String LIST_CATEGORIES = "produtos/listar_categorias/";
  static const String LIST_PRODUCTS = "produtos/listar/";
  static const String LIST_PRODUCTS_HIGHLIGHTS = "produtos/listarDest/";

  //cart

  static const String TAKE_CART = "carrinho/pegar_carrinho/";
  static const String ADD_TO_ITEM = "carrinho/adicionar_item/";
  static const String ADD_ITEM_TO_CART = "carrinho/adicionar_item/";
  static const String LIST_ITEMS_CART = "carrinho/listar/";
  static const String DELETE_ITEM_CART = "carrinho/deletar/";
  static const String UPDATE_ITEM_CART = "carrinho/atualizar/";

  //pedidos

  static const String ADD_ORDER = "pedidos/adicionar/";
  static const String LIST_ORDERS = "pedidos/listar/";
  static const String LOAD_ORDER_DETAILS = "pedidos/detalhes/";

  //pagamentos

  static const String ADD_PAYMENT = "pagamentos/adicionar/";
  static const String LIST_PAYMENTS = "pagamentos/listar/";
  static const String CREATE_TOKEN_CARD = "pagamentos/criarTokenCartao/";


}