# Internet Connection Checker 

The **Internet Connection Checker** is a Flutter package designed to swiftly verify your internet connection, even on mobile networks, with subsecond response times.

[![pub package][package_svg]][package]
[![GitHub][license_svg]](LICENSE)

[![GitHub issues][issues_svg]][issues]
[![GitHub issues closed][issues_closed_svg]][issues_closed]

<hr />

This library equips you with the capability to monitor and validate internet connectivity by assessing reachability to various `Uri`s. It leverages the `connectivity_plus` package for tracking connectivity alterations and the `http` package for executing network requests.

## Features

- Determine internet connectivity status
- Observe alterations in internet connectivity

## Supported Platforms

| Platform | Check Connectivity | Listen for Changes |
| :------: | :----------------: | :----------------: |
| Android  |         ✅         |         ✅         |
|   iOS    |         ✅         |         ✅         |
|  macOS   |         ✅         |         ✅         |
|  Linux   |         ✅         |         ✅         |
| Windows  |         ✅         |         ✅         |
|   Web    |         ✅         |         ✅         |

## Permissions

### Android

In your `AndroidManifest.xml` file, include the following permissions:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### macOS

Add the following permissions to your macOS `.entitlements` files:

```entitlements
<key>com.apple.security.network.client</key>
<true/>
```

For further details, consult the [Flutter Networking Documentation].

## Usage

### 1. Add dependency

Append the `internet_connection_checker` package to your `pubspec.yaml` file:

```yaml
dependencies:
  internet_connection_checker: ^2.1.0
```

### 2. Import the package

Integrate the `internet_connection_checker_plus` package into your Dart file:

```dart
import 'package:internet_connection_checker/internet_connection_checker.dart';
```

### 3. Checking for internet connectivity

The easiest way to examine internet connectivity is by employing the `InternetConnection` class:

```dart
bool result = await InternetConnection().hasInternetAccess;
```

### 4. Listening for internet connectivity changes

The `InternetConnection` class also delivers a stream of `InternetStatus` that can be utilized to monitor shifts in internet connectivity:

```dart
final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
  switch (status) {
    case InternetStatus.connected:
      // The internet is now connected
      break;
    case InternetStatus.disconnected:
      // The internet is now disconnected
      break;
  }
});
```

Remember to cancel the subscription when it's no longer needed. This prevents memory leaks and frees up resources:

```dart
listener.cancel();
```

### 5. Adding custom `Uri`s to check

You can configure the `InternetConnection` class to evaluate custom `Uri`s for internet connectivity:

```dart
final connection = InternetConnection.createInstance(
  customCheckOptions: [
    InternetCheckOption(uri: Uri.parse('https://example.com')),
  ],
);
```

#### Default `Uri`s

The `InternetConnection` class defaults to the following `Uri`s:

| URI                                            | Description                                                |
| :--------------------------------------------- | :--------------------------------------------------------- |
| `https://icanhazip.com`                        | Response time is less than `100ms`, CORS enabled, no-cache |
| `https://jsonplaceholder.typicode.com/posts/1` | Response time is less than `100ms`, CORS enabled, no-cache |
| `https://pokeapi.co/api/v2/pokemon/1`          | Response time is less than `100ms`, CORS enabled, no-cache |
| `https://reqres.in/api/users/1`                | Response time is less than `100ms`, CORS enabled, no-cache |

#### Some Tested URIs

| URI                                                 | Description                                             |
| :-------------------------------------------------- | :------------------------------------------------------ |
| `https://ifconfig.me/ip`                            | Payload is less than `50` bytes, CORS enabled, no-cache |
| `https://ipecho.net/plain`                          | Payload is less than `50` bytes, CORS enabled, no-cache |
| `https://lenta.ru`                                  | Russia supported, CORS enabled, no-cache                |
| `https://www.gazeta.ru`                             | Russia supported, CORS enabled, no-cache                |
| `https://ipapi.co/ip`                               | CORS enabled, no-cache                                  |
| `https://api.adviceslip.com/advice`                 | CORS enabled, no-cache                                  |
| `https://api.bitbucket.org/2.0/repositories`        | CORS enabled, no-cache                                  |
| `https://www.boredapi.com/api/activity`             | CORS enabled, no-cache                                  |
| `https://api.thecatapi.com/v1/images/search`        | CORS enabled, no-cache                                  |
| `https://api.coindesk.com/v1/bpi/currentprice.json` | CORS enabled, no-cache                                  |

## Credits

This package is a cloned and modified version of the [internet_connection_checker] package, which itself is a cloned and modified version of the [data_connection_checker] package, which is no longer actively maintained.

The goal of this package is to offer support for the `web` platform, a feature currently absent in the [internet_connection_checker] package.

<!-- Badges URLs -->

[package_svg]: https://img.shields.io/pub/v/internet_connection_checker.svg?color=blueviolet
[license_svg]: https://img.shields.io/github/license/OutdatedGuy/internet_connection_checker_plus.svg?color=purple
[issues_svg]: https://img.shields.io/github/issues/OutdatedGuy/internet_connection_checker_plus.svg
[issues_closed_svg]: https://img.shields.io/github/issues-closed/OutdatedGuy/internet_connection_checker_plus.svg?color=green

<!-- Links -->

[Flutter Networking Documentation]: https://docs.flutter.dev/data-and-backend/networking
[package]: https://pub.dev/packages/internet_connection_checker_plus
[issues]: https://github.com/OutdatedGuy/internet_connection_checker_plus/issues
[issues_closed]: https://github.com/OutdatedGuy/internet_connection_checker_plus/issues?q=is%3Aissue+is%3Aclosed
[internet_connection_checker]: https://github.com/RounakTadvi/internet_connection_checker
[data_connection_checker]: https://pub.dev/packages/data_connection_checker