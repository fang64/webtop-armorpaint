FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Bambu Studio version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="fang64"

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

RUN \
  echo "**** install packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    libfuse2 \
    wget \
    unzip \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav \
    git \
    build-essentials \
    clang \
    libxinerama-dev \
    libxrandr-dev \
    libasound2-dev \
    libxi-dev \
    mesa-common-dev \
    libgl-dev \
    libxcursor-dev \
    libvulkan-dev \
    libgtk-3-dev \
    libudev-dev \
    firefox \
    mousepad \
    xfce4-terminal \
    xfce4 \
    xubuntu-default-settings \
    xubuntu-icon-theme && \
  echo "**** Install Armor Paint ****" && \
  cd /opt && \
  git clone --recursive https://github.com/armory3d/armortools && \
  cd armortools/armorpaint && \
  ../armorcore/Kinc/make --from ../armorcore -g opengl --compile && \
  cd ../armorcore/Deployment && \
  strip ArmorPaint && \
  echo "**** xfce tweaks ****" && \
  rm -f \
    /etc/xdg/autostart/xscreensaver.desktop && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
