FROM ubuntu

WORKDIR /usr/src

RUN set -eux; apt-get update; \
    apt-get install -y --no-install-recommends ffmpeg nginx supervisor; \
    #
    # clean up
    rm -rf /var/lib/apt/lists/*;

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN mkdir -p /var/log/supervisor; \
    mkdir -p /var/www/html; \
    groupadd --gid $USER_GID $USERNAME; \
    useradd --uid $USER_UID --gid $USERNAME --shell /bin/bash --create-home $USERNAME; \
    chown $USERNAME /var/www/html;

COPY supervisord.conf entrypoint.sh ./
COPY profiles profiles

ENV USER=$USERNAME

CMD ["./entrypoint.sh"]
