
import 'dart:convert';
import 'dart:io';


extension HttpClientResponseX on HttpClientResponse {

	Future<dynamic> decodeJson() async => jsonDecode(
		await transform(utf8.decoder).join(),
	);
}
