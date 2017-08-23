docker-android-avd
================

[Docker](https://www.docker.com/) image of [Android SDK](https://developer.android.com) with configured AVD.

Usage
--------------

    docker run -it --device /dev/kvm -p 5554:5554 -p 5555:5555 aiwin/android-avd-base


Build
--------------

Run `build.sh` script to build and push the image to default location

    aiwin/android-avd-base:latest

If you want to build and push the image to diferent location, define the following
variables before the execution of the script:

- REPOSITORY. Docker repository
- REGISTRY. Docker registry
- TAG. Tag or version
