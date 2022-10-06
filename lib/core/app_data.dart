import '../src/model/product.dart';

class AppData {
  AppData._();

  static const dummyText =
      'History of Jeans and Denim. Jeans are pants made from denim or dungaree cloth. They were invented by Jacob Davis and Levi Strauss in 1873 and a worn still but in a different context. Jeans are named after the city of Genoa in Italy, a place where cotton corduroy, called either jean or jeane, was manufactured.';

  static List<Product> products = [
    Product(
        id: 'p1',
        title: 'Faded Men Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FScku4.jpg',
        price: 15.99),
    Product(
        id: 'p2',
        title: 'Gray Men Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FScetr.png',
        price: 19.99),
    Product(
        id: 'p3',
        title: 'Black Men Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FSc4nf.jpg',
        price: 12.49),
    Product(
        id: 'p4',
        title: 'Blue Men Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FScn31.jpg',
        price: 19.49),
    Product(
        id: 'p5',
        title: 'Faded Black Men Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FScGqm.jpg',
        price: 20.99),
    Product(
        id: 'p6',
        title: 'Blue Women Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FSgMkW.jpg',
        price: 11.99),
    Product(
        id: 'p7',
        title: 'Gray Women Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FSgTF0.jpg',
        price: 12.49),
    Product(
        id: 'p8',
        title: 'Faded Black Women Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FSgojT.jpg',
        price: 15.99),
    Product(
        id: 'p9',
        title: 'Faded Blue Women Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FSgXRc.jpg',
        price: 19.99),
    Product(
        id: 'p10',
        title: 'Bright Blue Women Jean',
        description: dummyText,
        imageUrl: 'https://i.im.ge/2022/07/21/FSgrTL.jpg',
        price: 20.99),
  ];
}
