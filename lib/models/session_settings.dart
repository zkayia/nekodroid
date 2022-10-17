
import 'package:flutter/material.dart';


@immutable
class SessionSettings {

  final bool privateBrowsingEnabled;
  
  const SessionSettings({
    this.privateBrowsingEnabled=false,
  });

  SessionSettings copyWith({
    bool? privateBrowsingEnabled,
  }) => SessionSettings(
    privateBrowsingEnabled: privateBrowsingEnabled ?? this.privateBrowsingEnabled,
  );
}
