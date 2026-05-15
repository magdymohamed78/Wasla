#!/usr/bin/env sh
set -eu

target="${1:-apk}"

copy_apk_outputs() {
  mkdir -p /output
  cp build/app/outputs/flutter-apk/app-release.apk /output/app-release.apk
}

copy_appbundle_outputs() {
  mkdir -p /output
  cp build/app/outputs/bundle/release/app-release.aab /output/app-release.aab
}

case "$target" in
  apk)
    flutter build apk --release
    copy_apk_outputs
    ;;
  appbundle | aab)
    flutter build appbundle --release
    copy_appbundle_outputs
    ;;
  *)
    exec "$@"
    ;;
esac
