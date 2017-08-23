FROM aiwin/android-base

LABEL maintainer="javier.boo@aiwin.es"

# ADB and terminal ports of AVD
EXPOSE 5554 5555

ENV SHELL /bin/bash
ENV ANDROID_AVD_NAME docker-avd

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes --no-install-recommends lib32stdc++6 lib32z1 libqt5widgets5 libqt5svg5 file socat supervisor && \
    apt-get --quiet clean --yes && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN $ANDROID_SDK_HOME/tools/bin/sdkmanager "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86" && \
    yes | $ANDROID_SDK_HOME/tools/bin/sdkmanager --licenses && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager --update && \
    echo no | $ANDROID_SDK_HOME/tools/bin/avdmanager create avd -f -n ${ANDROID_AVD_NAME} -k "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86" --abi google_apis/x86

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY socat.sh /usr/local/bin/socat.sh

# https://stackoverflow.com/a/44386974
RUN mkdir -p $ANDROID_SDK_HOME/platforms && \
    mkdir -p $HOME/scripts/android && \
    mkdir -p /var/log/supervisor && \
    wget --quiet --output-document=$HOME/scripts/android/android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator && \
    chmod +x $HOME/scripts/android/android-wait-for-emulator && \
    chmod +x /usr/local/bin/socat.sh    

CMD /usr/bin/supervisord
