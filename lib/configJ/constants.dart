class WSConstantes {

  static const String URLBASE = "https://www.bcremates.app.br/apiv3/user/";
  static const String URL = "https://www.bcremates.app.br/";
  static const String URL_VIACEP = "https://viacep.com.br/ws/";
  static const String URL_AVATAR_USER = URL + "usuarios/atualizar_avatar";
  static const String URL_AVATAR = URL + "uploads/avatar/";
  static const String URL_CHAT = URL + "uploads/chat/";
  static const String URL_AD = URL + "uploads/anuncios/";
  static const String URL_BANNER = URL + "uploads/banners/";
  static const String URL_CHAT_IMAGE = URL + "uploads/chat/imagens/";
  static const String URL_CHAT_AUDIO = URL + "uploads/chat/audios/";
  static const String URL_LEILAO = URL + "uploads/leiloes/";
 // url_leilao

  static const String FCM_TYPE_ANDROID = "1";
  static const String FCM_TYPE_IOS = "2";
  static const String TOKEN = "59N59vQd";
  /**:::Requests:::**/
  static const String LOGIN = "usuarios/login";
  static const String DOIS_FATORES = "usuarios/doisFatores";
  static const String REGISTRER = "usuarios/cadastroapp";
  static const String LIST_CATEGORY = "usuarios/listCategorias/";
  static const String PRICE_TURBINAR = "usuarios/valorTurbinar/";
  static const String LIST_CATEGORY_ANUNCIO_T = "anuncios/listCategorias/";
  static const String LIST_CATEGORY_ANUNCIO = "anuncios/listCategoriasAdd/";
  static const String LIST_SUB_CATEGORY = "anuncios/listSubCategorias/";
  static const String LIST_SUB_CATEGORY_ANUNCIO = "anuncios/listSubCategoriasAdd/";
  static const String LIST_BANNER = "usuarios/listBanners/";
  static const String LIST_CONSERVACAO = "anuncios/listConservacao/";
  static const String LIST_CONSERVACAO_ANUNCIO = "anuncios/listConservacaoAdd/";
  static const String LIST_ENTREGA = "anuncios/listEntrega/";
  static const String LIST_ENTREGA_ANUNCIO = "anuncios/listEntregaAdd/";
  static const String LIST_ENTREGA_FAVORITE = "anuncios/listEnderecoFavorito/";
  static const String SAVE_ENTREGA_FAVORITE = "anuncios/saveEnderecoFavorito/";
  static const String UPDATE_STATUS_AD = "anuncios/editarStatusAnuncio/";
  static const String DELETE_AD = "anuncios/deletarAnuncio/";
  static const String SEARCH_CITY = "anuncios/buscarCidades/";
  static const String SAVE_PHOTO_AD = "anuncios/saveFotosAnuncio/";
  static const String UPDATE_PHOTO_AD = "anuncios/updateFotosAnuncio/";
  static const String SAVE_AD = "anuncios/saveAnuncio/";
  static const String UPDATE_AD = "anuncios/editarAnuncio/";
  static const String UPDATE_LOCATION = "usuarios/updateLocation/";
  static const String LIST_REDES = "usuarios/listRedesSociais/";
  static const String PERFIL_USER = "usuarios/perfil/";
  static const String UPDATE_USER = "usuarios/updateUser";
  static const String UPDATE_PASSWORD = "usuarios/updatepassword/";
  static const String UPDATE_CATEGORY = "usuarios/updateInteresses";
  static const String RECOVERRY_PASSWORD = "usuarios/recuperarsenha/";
  static const String SAVE_FCM = "usuarios/savefcm";
  static const String STATISTICS = "cruzadas/estatisticas";
  static const String LISTNIVEIS = "cruzadas/listNiveis";
  static const String NOTIFICATION = "usuarios/notificacoes/";
  static const String LIST_AD = "anuncios/listAnunciosFiltro";
  static const String LIST_AD_NEXT = "anuncios/listAnunciosProximos/";
  static const String LIST_WORDS = "anuncios/buscarPalavra";
  static const String ZERA_CRUZADA = "cruzadas/zerar";
  static const String CONCLUDE_CRUZADA = "cruzadas/concluir";
  static const String DESATIVE_ACCOUNT = "usuarios/desativarconta";
  static const String LIST_FAVORITE = "favoritos/listFavoritos/";
  static const String LIST_PAYMENT = "pagamentos/listar";
  static const String ADD_FAVORITE = "favoritos/addFavorito/";
  static const String ANUNCIO_DETAIL = "anuncios/anuncioDetalhes/";
  static const String DELETE_FAVORITE = "favoritos/deleteFavoritos/";
  static const String LIST_CHAT = "chat/listchat";
  static const String LIST_CHAT_CONVERSA = "chat/listchatID/";
  static const String UPDATE_CHAT = "chat/updatechat/";
  static const String SAVE_CHAT = "chat/savechat/";
  static const String N_LIDA = "chat/mensagemNLida";
  static const String LIST_ENTREGAS = "entregas/listEntregas";
  static const String LIST_INTERESS = "entregas/listInteressados";
  static const String CONFIRM_DELIVERY = "entregas/confirmarEntrega";
  static const String DELETE_PHOTO = "anuncios/deletarFotos/";
  static const String AVALIAR_RECEBIMENTO = "relatorios/avaliarRecebimento";
  static const String RELATAR_PROBLEM = "relatorios/relatarProblemas";
  static const String LIST_MOTIVATION = "entregas/motivos";
  static const String STATUS_AVALIAR = "relatorios/listAvaliacaoPendente";
  static const String OPEN_AD = "relatorios/entrouNoAnuncio";
  static const String REMOVER_INTERSS = "entregas/retirarInteresse";
  static const String LIST_SIMPLE_FILTER = "leiloes/listNomeLeiloes/";
  static const String LIST_ALL_FILTER = "leiloes/listAllLeiloes/";
  static const String LIST_ALL_LOTES = "leiloes/listAllLotes/";
  static const String DAR_LANCE = "leiloes/saveLance/";


  /**:::PLAN:::**/
  static const String PLAN_USER = "usuarios/planoUser/";
  static const String LIST_PLAN = "usuarios/listPlanos/";
  static const String REMOVE_PLAN = "pagamentos/removerPlano";

  /**:::TURBINAR:::**/
  static const String VALUE_TURBINADO = "usuarios/valorTurbinado/";
  static const String PAYMENT = "pagamentos/adicionar";
  static const String PAYMENT_CARD_TOKEN = "pagamentos/criarTokenCartao";
  static const String PAYMENT_CARD_TOKEN_ASS = "pagamentos/criarTokenCartaoAssinatura";

  /**:::Body:::**/
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String PALAVRA_CHAVE = "palavra_chave";
  static const String PALAVRA = "palavra";
  static const String PHONE = "celular";
  static const String NAME = "nome";
  static const String BIRTH = "data_nascimento";
  static const String ID_USER = "id_user";
  static const String USER_ID = "user_id";
  static const String TYPE = "type";
  static const String TIPO = "tipo";
  static const String REGIST_ID = "registration_id";
  static const String ID = "id";
  static const String ID_DE = "id_de";
  static const String ID_PARA = "id_para";
  static const String ID_MOTIVACAO = "id_motivo";
  static const String ID_USERS = "id_usuario";
  static const String CATEGORY_ID = "categoria_id";
  static const String CATEGORY = "categoria";
  static const String ENTREGA = "entrega";
  static const String PRIVACIDADE = "privacidade";
  static const String SUBCATEGORY = "subcategoria";
  static const String CONSERVACAO = "conservacao";
  static const String CODE_USER = "codigo_user";
  static const String CODE = "codigo";
  static const String ID_NIVEL = "id_nivel";
  static const String AD_ID = "anuncio_id";
  static const String ID_AD = "id_anuncio";
  static const String ID_PHOTO = "id_foto";
  static const String LATITUDE = "latitude";
  static const String LONGITUDE = "longitude";
  static const String INTERESSES = "interesses";
  static const String CITY = "cidade";
  static const String ADRESS = "endereco";
  static const String APELIDO = "apelido";
  static const String BAIRRO = "bairro";
  static const String NUMERO = "numero";
  static const String COMPLEMENTO = "complemento";
  static const String STATES = "estado";
  static const String CEP = "cep";
  static const String DESCRIPTION = "descricao";
  static const String TOKENID = "token";
  static const String STATUS = "status";
  static const String STAR = "estrelas";
  static const String DISTANCIA_IN = "distancia_in";
  static const String DISTANCIA_OUT = "distancia_out";
  static const String DOCUMENT = "documento";


  /**:: Pagamentos ::**/
  static const String ID_PLAN_AD = "id_plano_anuncio";
  static const String CPF = "cpf";
  static const String PAYMENT_ID = "payment_id";
  static const String TYPER_PAYMENT = "tipo_pagamento";
  static const String CARD = "card";
  static const String CARD_NUMBER = "card_number";
  static const String EXPIRATION_MONTH = "expiration_month";
  static const String EXPIRATION_YEAR = "expiration_year";
  static const String SECURITY_CODE = "security_code";
  static const String STATUS_ORDEN = "status_order";
  static const String ID_ORDER = "id_order";

  /**:::Validações:::**/
  static const String MSG_NOME_INVALIDO = 'Preencha o campo Nome';
  static const String MSG_CPF_INVALIDO = 'Preencha o campo CPF';
  static const String MSG_EMAIL_EMPTY = 'Preencha o campo E-mail';
  static const String MSG_APELIDO_EMPTY = 'Preencha o campo Apelido';
  static const String MSG_USUARIO_EMPTY = 'Preencha o campo Usuário';
  static const String MSG_EMAIL_INVALIDO = 'Email inválido, tente novamente';
  static const String MSG_ORGAN_INVALIDO = 'Selecione o Orgão';
  static const String MSG_PASSWORD_INVALIDO = 'Senha inválida, tente novamente';
  static const String MSG_PASSWORD_EMPTY = 'Preencha o campo Senha';
  static const String MSG_PHONE_INVALIDO = 'Celular inválido, tente novamente';
  static const String MSG_PHONE_EMPTY = 'Preencha o campo Whatsapp';
  static const String MSG_CO_PASSWORD_INVALIDO = 'As senhas fornecidas não são idênticas, por favor, verifique-as e tente novamente';
  static const String MSG_CO_PASSWORD_EMPTY = 'Preencha o campo Confirmar Senha';


  static const String MSG_CATEGORIA_EMPTY = 'Selecione uma categoria';
  static const String MSG_MOTIVO_EMPTY = 'Selecione um motivo para seu problema';
  static const String MSG_SUBCATEGORIA_EMPTY = 'Selecione uma Subcategoria';
  static const String MSG_TITLE = 'Preencha o campo titulo';
  static const String MSG_DESCRIPTION = 'Preencha o campo descrição';
  static const String MSG_CONSERVACAO_EMPTY = 'Selecione o estado de conservação';


  static const String MSG_CEP_EMPTY = 'Preencha o campo CEP';
  static const String MSG_RUA_EMPTY = 'Preencha o campo Logradouro';
  static const String MSG_NUMERO_EMPTY = 'Preencha o campo Número';
  static const String MSG_BAIRRO_EMPTY = 'Preencha o campo Bairro';
  static const String MSG_CIDADE_EMPTY = 'Preencha o campo Cidade';
  static const String MSG_ESTADO_EMPTY = 'Preencha o campo Estado';
  static const String MSG_TIPO_ENTREGA_EMPTY = 'Selecione o tipo de entrega';
  static const String MSG_INTERESS = 'Selecione um interessado';

  /**:::INICIA FIREBASE NO IOS:::**/
  static const String API_KEY = 'AIzaSyC29OHcYG-evZDs1_POKS7yjI_eZlWCsDk';
  static const String APP_ID = '1:85702348718:android:b34cc14ebc3330a05d823f';
  static const String MESSGING_SENDER_ID = '85702348718';
  static const String PROJECT_ID = 'cruzadista-eb3ab';

}