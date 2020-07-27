# hls-restream
Restream live content as HLS using ffmpeg in docker.

# Usage

You need to have docker & docker-compose installed.

1. Clone this repository:
```sh
git clone https://github.com/m1k1o/hls-restream
cd hls-restream
```

2. Modify `docker-compose.yml` and add your own sources:
```yml
version: "3.4"
services:
  hls:
    build: "./"
    container_name: "hls"
    restart: "always"
    tmpfs:
      - "/var/www/html:mode=777,size=128M,uid=1000,gid=1000"
    ports:
      - "80:80"
    environment:
      SOURCES: |
        ch1     rtsp://192.168.1.5:554/ch1
        ch2     rtsp://192.168.1.5:554/ch2
        ch1_hd  http://192.168.1.6/stream/channelid/8967896?profile=pass
        ch2_hd  http://192.168.1.6/stream/channelid/4969639?profile=pass
```

3. Start docker compose (run this everytime you modify stream sources):
```sh
docker-compose up -d --build
```

4. Watch streams:
```
http://localhost/ch1.m3u8
http://localhost/ch2.m3u8
http://localhost/ch1_hd.m3u8
http://localhost/ch2_hd.m3u8
```

In case or error, troubleshoot:

```sh
docker logs hls
docker exec -it hls sh -c 'cd /var/log/supervisor && /bin/bash'
```
