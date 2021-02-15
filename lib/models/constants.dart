class Constants {
  static final checkBalance = '*101#';
  static final checkInternetBalance = '*109*2#';
  static final getMyPhoneNumber = '*161#';
  static final statusIamInTouch = '*110*20#';
  static final buy1Gb = '*109*2*1#';
  static final buy5Gb = '*109*2*5#';
  static final buy50Gb = '*109*2*50#';
  static final get25Money = '*101*1*25#';
  static final get50Money = '*101*1*50#';
  static final get100Money = '*101*1*100#';
}

enum RequestState {
  Ongoing,
  Success,
  Error,
}

final emergencyList = <String, String>{
  '101': 'Служба МЧС',
  '102': 'Служба Полиции',
  '103': 'Скорая Медицинская Помощь',
  '104': 'Аварийная Газовая Служба'
};

final getMoney = <String, String>{
  '*101*1*25#': 'на баланс поступает 25 руб., стоимость услуги 3 руб.',
  '*101*1*50#': 'на баланс поступает 50 руб., стоимость 5 руб.',
  '*101*1*100#': 'на баланс поступает 100 руб., стоимость 7 руб.',
};

final yuoHaveCall = <String, String>{
  '*110*21#':
      'активации услуг «Вам звонили» и «Я на связи».При вводе данного запроса, поступит смс с текстом «Уважаемый абонент! Услуга «Вам звонили» подключена».',
  '*110*20# ': 'проверка состояния услуги',
  '*110*22#':
      'отключение услуги После активации услуги «Вам звонили», услуга «Я на связи» подключится автоматически.',
};

final regularList = <String, String>{
  '*101#':
      'информация о состоянии счета, льготных SMS, льготных минутах на РФ, состоянии кредита',
  '*101*101#':
      'информация по SMS о состоянии счета, льготных SMS, льготных минутах на РФ, состоянии кредита (приходит как информационное SMS. на дисплее прописано «Отправлена информационная SMS по номеру: 38071ХХХХХХХ»; автоматически поступает SMS с балансом в течение 60 секунд)',
  '*161# ': 'определение своего номера',
  '*104*71XXXXXXX#':
      'услуга «Перезвони мне» (ввод номера Феникс возможен в форматах 71 / 071 / 38071 / +38071)',
  '*43#': 'подключение услуги «вторая линия/ожидание вызова»'
};
