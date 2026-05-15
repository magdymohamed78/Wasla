# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG FLUTTER_VERSION=3.41.1
ARG ANDROID_SDK_ROOT=/opt/android-sdk
ARG ANDROID_PLATFORM_VERSION=36
ARG ANDROID_BUILD_TOOLS_VERSION=36.0.0
ARG ANDROID_COMPAT_PLATFORM_VERSION=34
ARG ANDROID_COMPAT_BUILD_TOOLS_VERSION=34.0.0
ARG ANDROID_NDK_VERSION=28.2.13676358

ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libglu1-mesa \
        openjdk-17-jdk-headless \
        unzip \
        xz-utils \
        zip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch ${FLUTTER_VERSION} --depth 1 https://github.com/flutter/flutter.git /opt/flutter \
    && git config --global --add safe.directory /opt/flutter \
    && flutter config --no-analytics \
    && flutter precache --android

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -o /tmp/cmdline-tools.zip \
    && unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip

RUN yes | sdkmanager --licenses >/dev/null || true \
    && sdkmanager \
        "platform-tools" \
        "platforms;android-${ANDROID_PLATFORM_VERSION}" \
        "platforms;android-${ANDROID_COMPAT_PLATFORM_VERSION}" \
        "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
        "build-tools;${ANDROID_COMPAT_BUILD_TOOLS_VERSION}" \
        "cmake;3.22.1" \
        "ndk;${ANDROID_NDK_VERSION}" \
    && yes | sdkmanager --licenses >/dev/null \
    && flutter config --android-sdk ${ANDROID_SDK_ROOT} \
    && yes | flutter doctor --android-licenses >/dev/null

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN printf "sdk.dir=%s\nflutter.sdk=/opt/flutter\nflutter.buildMode=release\n" "${ANDROID_SDK_ROOT}" > android/local.properties \
    && flutter pub get \
    && flutter gen-l10n

ENTRYPOINT ["sh", "docker/android-build.sh"]
CMD ["apk"]
