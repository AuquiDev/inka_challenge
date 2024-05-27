
import 'package:inka_challenge/api/path_key_api.dart';

class TProveedor {
  
  static getProveedorAlmacen() async {
    // final pb = PocketBase('https://planet-broken.pockethost.io');

    final records = await ar.collection('proveedor_app').getFullList(
    sort: '-created',
    );
    return records;
  }
}