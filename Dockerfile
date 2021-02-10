FROM openjdk:11-slim

ARG TOOLS_VERSION=30.0.2
ARG PLATFORM=android-30

LABEL maintainer="Barry Lagerweij" \
  maintainer.email="b.lagerweij@carepay.com" \
  description="Android Builder"

RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \
    unzip -q commandlinetools-linux-6858069_latest.zip -d /tmp/android-sdk && \
    rm commandlinetools-linux-6858069_latest.zip && \
    mkdir -p ~/.android && \
    echo "count=0" >> ~/.android/repositories.cfg && \
    echo yes | /tmp/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=/tmp/android-sdk \
        "build-tools;${TOOLS_VERSION}" \
        "platforms;${PLATFORM}" \
        | grep -v '^\[' && \
    rm -rf /tmp/android-sdk/extras /tmp/android-sdk/emulator /tmp/android-sdk/tools/lib/monitor-* && \
    mkdir /tmp/project && \
    echo "sdk.dir=/tmp/android-sdk" > /tmp/project/local.properties
ENV ANDROID_HOME /tmp/android-sdk
WORKDIR /tmp/project
