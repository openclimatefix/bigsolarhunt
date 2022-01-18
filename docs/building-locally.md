# Building the App Locally (not recommended)

To build a release appbundle locally, the process to be followed is functionally the same as that
outlined in the `gitlab-ci.yml` pipeline.

## Keystore and key.properties

To sign the appbundle, a **keystore** is required, the value of which can be found in the Gitlab CI
variables. Then, `android/key.properties` must be defined as can be seen in the
build-debug-android `gitlab-ci.yml` pipeline, with the following structure:

```txt
storePassword=password_of_the_keystore
keyPassword=password_of_the_key
keyAlias=key
storeFile=/path/to/your/keystore/file.jks
```

## Environment Variables and config.dart

To prevent the requirement of checking secrets into version control, things like the Mapillary API
key and the Telegram Bot token are passed into the app dynamically at build time. These variables
are defined in the `Env` class in `lib/Config/config.dart`, and are passed to flutter at build time
via the command flag `--dart-define`, see an
example [here](https://dartcode.org/docs/using-dart-define-in-flutter/).

## Build Command

The appbundle can then be built via

```shell
$ flutter build appbundle \
      --release \
      --build-name=<build name> \
      --build-number=<build number> \
      --dart-define=MAPILLARY_BEARER_TOKEN=${MAPILLARY_BEARER_TOKEN} \
      --dart-define=MAPILLARY_CLIENT_ID=${MAPILLARY_CLIENT_ID} \
      --dart-define=TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN} \
      --dart-define=TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}
```

If you see the following exception:

```shell
Flutter SDK not found. Define location with flutter.sdk in the local.properties file.
```

create a `android/local.properties` file, with the following structure:

```txt
flutter.sdk=/path/to/flutter/instance
sdk.dir=/path/to/android/sdk
flutter.buildMode=debug
flutter.versionName=flutter.version.name
flutter.versionCode=1
```
