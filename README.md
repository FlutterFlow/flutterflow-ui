# flutterflow_ui

`flutterflow_ui` simplifies the process of adding FlutterFlow-generated UI code to your Flutter projects. It streamlines integration, saving you time and effort in your Flutter app UI development.

## Generate code in your FlutterFlow project

Go to your FlutterFlow project and click on the code icon and click on `View Code`

<img src="https://github.com/FlutterFlow/flutterflow-ui/blob/pooja/new_widgets/assets/package1.gif" width="500" />

You will be able to see the FlutterFlow generated code for your pages and components. Choose your desired page or component and copy the widget code and paste it in a new Flutter file in your Flutter project. 

Make sure to also add the generated model code in the same file or in a separate file as per your directory architecture. In some cases, it might be an empty file and you may be able to remove it later.

On pasting the code, you might see some errors that will be resolved after the following steps.

## Add Dependency

Now in your Flutter project, open your `pubspec.yaml` file and add `flutterflow_ui` under dependencies:

```yaml
dependencies:
  flutterflow_ui: <latest_version>
```
Remember to run `flutter pub get`

## Replace the flutter_flow dependencies with the package import

In your imports, you will see a bunch of `flutter_flow/flutter_flow...` imports that are usually present in a FlutterFlow project but with this package you can resolve these errors. 

Remove such imports
```dart
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
```

And replace it with the package import.

```dart
import 'package:flutterflow_ui/flutterflow_ui.dart';
```

## Remove any unnecessary code

At the starting of the build method, you may find a `context.watch<FFAppState>();` and that is helpful in a FlutterFlow project but in your Flutter project, you may have a different way to hold global constants and variables, so you can remove this line of code. 

You can also remove the provider import if that is not the state management you are using for your project. 

Also check if your model file (if present in a different file) is imported correctly.

Now you can run the FlutterFlow generated code in your Flutter project. 

__________________________________________





