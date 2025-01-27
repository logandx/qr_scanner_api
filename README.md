# qr_scanner_api

A new Flutter project. This project is an example of using MethodChannel vs JNI to scan QR code.

## Getting Started

This project is a starting point for a Flutter application.

Prerequisites:

    - JDK

    - Maven

    - (Optional) clang-format to format the generated C bindings

Step to generate the JNI code:
1. Add dependencies to pubspec.yaml
    ```yaml
    flutter pub add jni dev:jnigen
    ```
2. Create the top level jniconfig.yaml file

3. Run `flutter build apk`

4. Generate the bindings
    
    ```terminal
    dart run jnigen --config jnigen.yaml
    ```

    If you encounter this error below:
    ```terminal
    (jnigen) INFO: Building ApiSummarizer component. This might take some time. The build will be cached for subsequent runs.
    (jnigen) INFO: execute mvn compile --batch-mode --update-snapshots -f /Users/logandx/.pub-cache/hosted/pub.dev/jnigen-0.9.1/java/pom.xml

    /bin/sh: mvn: command not found

    maven exited with 127
    Unhandled exception:
    PathNotFoundException: Deletion failed, path = './.dart_tool/jnigen/target' (OS Error: No such file or directory, errno = 2)
    ```

    The error message indicates that the mvn (Maven) command is not found on your system, which is required by the jnigen tool. Here are the steps to resolve this issue:

    Install Maven

    Install Homebrew (if not already installed):
    If you don't have Homebrew installed, you can install it by running the following command in Terminal:

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
    
    Install Maven using Homebrew:

    Once Homebrew is installed, you can install Maven with the following command:

    ```sh
    brew install maven
    ```
    
    Verify Maven Installation:

    After installation, you can verify that Maven is installed correctly by checking its version:

    ```sh
    mvn -v
    ```
    
    You should see output indicating the version of Maven that is installed.

    Run the Command Again
    After Maven is installed, you can run the `dart run jnigen --config jnigen.yaml` command again. It should be able to find Maven and proceed with the build process.

    After installing Maven and trying to run the command again, you may encounter another error message:

    ```terminal
    (jnigen) INFO: ApiSummarizer.jar exists. Skipping build..
    (jnigen) INFO: trying to obtain gradle dependencies [getReleaseCompileClasspath]...
    (jnigen) INFO: Restoring build scripts
    Unhandled exception:


    gradle exited with status 1
    . This can be because the Android build is not yet cached. Please run `flutter build apk` in ./ and try again

    #0      AndroidSdkTools._runGradleStub (package:jnigen/src/tools/android_sdk_tools.dart:207:7)
    #1      AndroidSdkTools.getGradleClasspaths (package:jnigen/src/tools/android_sdk_tools.dart:144:7)
    #2      getSummary (package:jnigen/src/summary/summary.dart:136:34)
    #3      generateJniBindings (package:jnigen/src/generate_bindings.dart:31:21)
    <asynchronous suspension>
    #4      main (file:///Users/logandx/.pub-cache/hosted/pub.dev/jnigen-0.9.1/bin/jnigen.dart:18:3)
    <asynchronous suspension>
    ```
    For me, this is fixed by Upgrade dependency from 7.3.0 to 8.2.0 (trying to update to the latest version) in Android Studio. And then it works.

3. Now we need to change our app/build.gradle with the following line of code inside the android property:
    ```gradle
    externalNativeBuild {
        cmake {
            path "../../src/scanner/CMakeLists.txt"
        }
    }
    ```
    This will add the CMakeList file that was generated by JNIgen into our build.gradle.
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

For help getting started with JNIgen, view the
[online documentation](https://github.com/dart-lang/native/tree/main/pkgs/jnigen)

Other resources:
- [Java interop](https://dart.dev/interop/java-interop)
