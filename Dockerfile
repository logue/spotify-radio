FROM ubuntu
RUN apt update && apt upgrade -y

# Build spotifyd from source
# RUN apt install wget libasound2-dev libssl-dev pkg-config -y
# RUN wget -O - 'https://github.com/Spotifyd/spotifyd/archive/refs/tags/v0.3.5.tar.gz' | tar zxvf -
# RUN cd spotifyd-0.3.5 \
#   && cargo build --features pulseaudio_backend \
#   cp ./target/release/spotifyd /bin/spotifyd \
#   && cd ../

# Setup icecast2
RUN apt install pulseaudio alsa-utils darkice icecast2 -y
RUN sed "s/^load-module module-console-kit/#load-module module-console-kit/" -i /etc/pulse/default.pa \
  && sed "s/ENABLE=false/ENABLE=true/" -i /etc/default/icecast2 \
  && sed "s/hackme/prettybigpasswordthatnoonewouldguess/g" -i /etc/icecast2/icecast.xml \
  && sed "s/8000/20300/" -i /etc/icecast2/icecast.xml \
  && mkdir -p /audio \
  && chmod 0777 /audio \
  && useradd -u 1000 -m -d /home/user -s /bin/sh user \
  && usermod -aG audio user

# Setup Spotifyd
ADD start.sh /bin/start.sh
ADD spotifyd /bin/spotifyd
ADD darkice.cfg /home/user/darkice.cfg

USER user
RUN mkdir -p /home/user/.config/spotifyd
ADD spotifyd.conf /home/user/.config/spotifyd/spotifyd.conf
ADD custom_boot.sh /home/user/custom_boot.sh

USER root

EXPOSE 20300
ENTRYPOINT [ "/bin/start.sh" ]
