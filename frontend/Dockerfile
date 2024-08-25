FROM ubuntu:20.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
        autoconf \
        bash \
        bzip2 \
        curl \
        file \
        wget \
        unzip \
        gnupg \
        software-properties-common \
        vim \
        git \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        nodejs \
        npm

WORKDIR /app

#Flutter
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && add-apt-repository ppa:maarten-fonville/android-studio
RUN apt-get update && \
    apt-get -y -q install \
    xz-utils libglu1-mesa openjdk-8-jdk google-chrome-stable android-studio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*	

# Android
WORKDIR /usr/local
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /usr/local/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg 
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;28.0.3" "platform-tools" "platforms;android-29" "sources;android-29" "cmdline-tools;latest"
ENV PATH "$PATH:/usr/local/Android/sdk/platform-tools"


# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/usr/local/flutter/bin"

WORKDIR /app

# Flutter Web
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

#firebase emulator suiteのためのjava jdkダウンロード
RUN mkdir /usr/java \
    && cd /usr/java \
    && wget https://download.oracle.com/java/22/latest/jdk-22_linux-x64_bin.tar.gz \
    && tar zxvf jdk-22_linux-x64_bin.tar.gz && rm jdk-22_linux-x64_bin.tar.gz
ENV PATH "/usr/java/jdk-22.0.2/bin:$PATH"