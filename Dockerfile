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

RUN $ANDROID_SDK_HOME/tools/bin/sdkmanager "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86_64" && \
    yes | $ANDROID_SDK_HOME/tools/bin/sdkmanager --licenses && \
		$ANDROID_SDK_HOME/tools/bin/sdkmanager "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86_64" && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager --update && \
    echo no | $ANDROID_SDK_HOME/tools/bin/avdmanager create avd -f -n ${ANDROID_AVD_NAME} -k "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86_64" --abi google_apis/x86_64

RUN mkdir -p $HOME/scripts/android

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY socat.sh /usr/local/bin/socat.sh
COPY stop-emulators.sh $HOME/scripts/android/stop-emulators.sh
COPY wait-for-emulator.sh $HOME/scripts/android/wait-for-emulator.sh

RUN mkdir -p /var/log/supervisor && \
    chmod +x /usr/local/bin/socat.sh && \
    chmod +x $HOME/scripts/android/stop-emulators.sh && \
    chmod +x $HOME/scripts/android/wait-for-emulator.sh

CMD /usr/bin/supervisord
