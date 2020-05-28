FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive && \
    \   
    # Instalando o ca-certificates e adicionando as chaves
    apt update && \
    apt -y -q install ca-certificates wget gnupg1 sudo pulseaudio-utils && \
    dpkg --add-architecture i386 && \
    \   
    # Ajustando o client.conf do pulseaudio
    echo "daemon-binary = /bin/true" > /etc/pulse/client.conf && \
    echo "autospawn = no" >> /etc/pulse/client.conf && \
    echo "enable-shm = no" >> /etc/pulse/client.conf && \
    \   
    # Atualizar a lista de pacotes
    apt-get update && \
    apt -y -q upgrade && \
    \   
    # Adicionano PPA do Kodi
    apt -y install software-properties-common && \
    add-apt-repository ppa:team-xbmc/ppa && \
    apt update && \
    apt -y install kodi && \
    \   
    # Instalando algumas bibliotecas do Python
    apt -y -q install build-essential python-dev python3-pip python-setuptools && \
    pip3 install --user pycryptodomex && \
    \   
    # Fazendo uma limpeza
    unset DEBIAN_FRONTEND && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* /root/.bash_history && \
    rm -rf /etc/ssh/*key*

ENTRYPOINT echo "default-server = unix:/run/user/$user_id/pulse/native" >> /etc/pulse/client.conf ; sudo -u $USER kodi
