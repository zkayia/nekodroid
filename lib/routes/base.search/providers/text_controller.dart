
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final textControllerProv = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
