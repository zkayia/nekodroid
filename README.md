__The app no longer has any use since [neko-sama.fr](https://neko-sama.fr) sadly closed in September 2024__ *rip*


# nekodroid

![Demo animation](assets/img/nekodroid_logo.svg "Demo animation")

Unofficial android client for [neko-sama.fr](https://neko-sama.fr).

~~This app is still in active developpement, a stable release is soon to come.~~

[Screenshots](screenshots/ "Screenshots")

## Installation

<!-- Download and install the [Latest APK](https://github.com/zkayia/nekodroid/releases/latest) or [Build](#Build) one. -->

You can [Build](#Build) a working app but be aware that it wont be able to update to the stable release without data loss and possible incompatibilities.

## Build

Make sure to check out [docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android).

1. Clone this repo:
   ```
   git clone https://github.com/zkayia/nekodroid
   ```

2. Make sure your installed sdk fits the requirement in the [pubspec.yaml](pubspec.yaml) file (under `environment` > `sdk`).

3. Navigate to the project's root folder.

4. Install dependencies:
   ```
   flutter pub get
   ```

5. Follow
    [docs.flutter.dev/deployment/android#create-an-upload-keystore](https://docs.flutter.dev/deployment/android#create-an-upload-keystore)

   and
	  [docs.flutter.dev/deployment/android#reference-the-keystore-from-the-app](https://docs.flutter.dev/deployment/android#reference-the-keystore-from-the-app)

	 to setup apk signing.
	 Gradle configuration is already done.

6. Build the apk:
   ```
   flutter build apk
   ```
   To get an apk for each architecture add the `--split-per-abi` flag.