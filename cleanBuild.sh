#!/bin/bash
fvm flutter clean
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs

