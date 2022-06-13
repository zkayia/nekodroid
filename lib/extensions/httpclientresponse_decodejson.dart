
import 'dart:convert';
import 'dart:io';


extension HttpClientResponseDecodeJson on HttpClientResponse {

	Future<dynamic> decodeJson() async => jsonDecode(
		await transform(utf8.decoder).join(),
	);
}
