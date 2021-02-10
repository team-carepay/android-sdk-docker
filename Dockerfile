FROM openjdk:11-slim

ARG SDK=commandlinetools-linux-6858069_latest.zip
ARG TOOLS_VERSION=30.0.2
ARG PLATFORM=android-30

ENV DEBIAN_FRONTEND=noninteractive 

LABEL maintainer="Barry Lagerweij" \
  maintainer.email="b.lagerweij@carepay.com" \
  description="Android Builder"

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        jq \
        openssh-client \
        unzip \
    && \
    curl -sL https://dl.google.com/android/repository/${SDK} -o sdk.zip && \
    unzip -q sdk.zip -d /tmp/android-sdk && \
    rm sdk.zip && \
    mkdir -p ~/.android && \
    echo "count=0" >> ~/.android/repositories.cfg && \
    echo yes | /tmp/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=/tmp/android-sdk \
        "build-tools;${TOOLS_VERSION}" \
        "platforms;${PLATFORM}" \
        | grep -v '^\[' && \
    rm -rf /tmp/android-sdk/extras /tmp/android-sdk/emulator /tmp/android-sdk/tools/lib/monitor-* && \
    mkdir /tmp/project && \
    echo "sdk.dir=/tmp/android-sdk" > /tmp/project/local.properties && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

ENV ANDROID_HOME /tmp/android-sdk
WORKDIR /tmp/project
