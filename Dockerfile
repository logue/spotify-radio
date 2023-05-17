FROM ubuntu
RUN apt update && apt upgrade -y
RUN apt install pulseaudio alsa-utils darkice icecast2 lame nano -y

# Setup icecast2
ADD icecast.xml /etc/icecast2/icecast.xml
ADD 5-minutes-of-silence.mp3 /usr/share/icecast2/web/silence.mp3
RUN sed "s/^load-module module-console-kit/#load-module module-console-kit/" -i /etc/pulse/default.pa \
  && sed "s/ENABLE=false/ENABLE=true/" -i /etc/default/icecast2 \
  && mkdir -p /audio \
  && chmod 0777 /audio \
  && useradd -u 1000 -m -d /home/user -s /bin/sh user \
  && usermod -aG audio user

# Setup Spotifyd
ADD start.sh /bin/start.sh
ADD spotifyd /bin/spotifyd
RUN chmod 0755 /bin/spotifyd
ADD darkice.cfg /home/user/darkice.cfg

USER user
RUN chown -R $USER:$USER /home/$USER
RUN mkdir -p /home/user/.config/spotifyd
ADD spotifyd.conf /home/user/.config/spotifyd/spotifyd.conf
ADD custom_boot.sh /home/user/custom_boot.sh

USER root
# RUN PULSE_SERVER=unix:/run/user/1000/pulse/native amixer -D pulse sset Master 50%

EXPOSE 20300
EXPOSE 20301
ENTRYPOINT [ "/bin/start.sh" ]
