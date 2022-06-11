
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final webviewControllerProvider = StateProvider.autoDispose<InAppWebViewController?>(
	(ref) => null,
);
