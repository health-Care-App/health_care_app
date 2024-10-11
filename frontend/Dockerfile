FROM ubuntu:22.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && apt-get install -y \
        curl \
        git \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa \
        nodejs \
        npm \
        libc6:amd64 \
        libstdc++6:amd64 \
        libbz2-1.0:amd64 \
        libncurses5:amd64 \
        #linux desktopアプリ用パッケージ
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev \
        libstdc++-12-dev \
    && yes | apt install openjdk-21-jdk

# WORKDIR /usr/local/

# #install android sdk
# RUN mkdir -p Android/sdk/cmdline-tools \
#     && curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip?hl=ja \
#     && unzip commandlinetools.zip \ 
#     && rm commandlinetools.zip \
#     && mv ./cmdline-tools/ ./Android/sdk/cmdline-tools/latest

# ENV ANDROID_SDK_ROOT /usr/local/Android/sdk/
# ENV PATH "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
# #要検証
# ENV PATH "&quot;$ANDROID_SDK_ROOT/emulator:$PATH"

# #必要なパッケージのインストール
# RUN  yes | sdkmanager --licenses
# RUN sdkmanager "platform-tools" \
#     emulator \
#     "build-tools;35.0.0" \
#     "platforms;android-35" \
#     "sources;android-35" \
#     "system-images;android-35;google_apis_playstore;x86_64"
# RUN echo no | avdmanager create avd -n android35 -d "pixel_7_pro" -k "system-images;android-35;google_apis_playstore;x86_64"

WORKDIR /app

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/app/flutter/bin"

# Flutter プラットフォーム設定
RUN flutter config --enable-web
#android stdioのパッケージライセンス認証
RUN flutter doctor --android-licenses

#node
RUN npm install n -g \
    && n 20

#firebase
RUN npm install -g firebase-tools

#flutterFire CLIインストール
RUN dart pub global activate flutterfire_cli
ENV PATH "$PATH:/root/.pub-cache/bin"