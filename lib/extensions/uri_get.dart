
import 'dart:io';


extension UriWithGet on Uri {

	Future<HttpClientResponse> get({
		HttpClient? httpClient,
		Map<String, dynamic>? headers,
		bool preserveHeaderCase=false,
		bool followRedirects=false,
		bool persistentConnection=false,
	}) async {
		final client = httpClient ?? HttpClient();
		try {
			final request = await client.getUrl(this)
				..followRedirects = followRedirects
				..persistentConnection = persistentConnection;
			if (headers != null) {
				for (final header in headers.entries) {
					request.headers.add(
						header.key,
						header.value,
						preserveHeaderCase: preserveHeaderCase,
					);
				}
			}
			return request.close();
		} catch (e) {
			throw SocketException(
				"failed to get or parse uri '${toString()}', $e",
				address: InternetAddress(toString()),
				port: port,
			);
		} finally {
			if (httpClient == null) {
				client.close();
			}
		}
	}
}
