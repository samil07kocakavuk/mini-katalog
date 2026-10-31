import 'http_types.dart';
import 'network_exception.dart';

Future<FetchResponse> fetchResponse(String url) {
  throw const FetchException('Bu platformda ağ erişimi desteklenmiyor.');
}
