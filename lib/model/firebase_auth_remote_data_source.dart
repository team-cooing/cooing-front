import 'package:http/http.dart' as http;

class firebaseAuthRemoteDataSourcen {
  final String url = 'https://';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http.post(Uri.parse(url), body: user);

    return customTokenResponse.body;
  }
}
