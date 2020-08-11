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
      PROFILE: passthrough
      SOURCES: |
        # SD Channels:
        ch1     rtsp://192.168.1.5:554/ch1
        ch2     rtsp://192.168.1.5:554/ch2
        # HD Channels:
        ch1_hd  http://192.168.1.6/stream/channelid/8967896?profile=pass
        ch2_hd  http://192.168.1.6/stream/channelid/4969639?profile=pass
```

Profiles can you find in `profiles/` folder.
* passthrough - default, no transcoding.

H264 adaptive bitrate transcoding:
* abr_transcoding_sd - 360p and 480p
* abr_transcoding_hd - 360p, 480p and 720p
* abr_transcoding_hd_1080p - 360p, 480p, 720p and 1080p

H264 transcoding:
* transcoding_hd - 720p only
* transcoding_sd - 480p only

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

In case of error, troubleshoot:

```sh
docker logs hls
docker exec -it hls sh -c 'cd /var/log/supervisor && /bin/bash'
```

# NVIDIA GPU hardware acceleration

You will need to have [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) installed.

```
docker build -t hls_nvidia -f Dockerfile.nvidia .
docker run -d --gpus=all \
  --name hls_nvidia \
  -p 80:80 \
  -e 'PROFILE=transcoding_sd' \
  -e 'SOURCES=
        # SD Channels:
        ch1     rtsp://192.168.1.5:554/ch1
        ch2     rtsp://192.168.1.5:554/ch2
        # HD Channels:
        ch1_hd  http://192.168.1.6/stream/channelid/8967896?profile=pass
        ch2_hd  http://192.168.1.6/stream/channelid/4969639?profile=pass
  ' \
  hls_nvidia
```

## Supported inputs

```
| Codec      | CUVID       | Codec Name                                |
| ---------- | ----------- | ----------------------------------------- |
| h264       | h264_cuvid  | H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 |
| hevc       | hevc_cuvid  | H.265 / HEVC                              |
| mjpeg      | mjpeg_cuvid | Motion JPEG                               |
| mpeg1video | mpeg1_cuvid | MPEG-1 video                              |
| mpeg2video | mpeg2_cuvid | MPEG-2 video                              |
| mpeg4      | mpeg4_cuvid | MPEG-4 part 2                             |
| vc1        | vc1_cuvid   | SMPTE VC-1                                |
| vp8        | vp8_cuvid   | On2 VP8                                   |
| vp9        | vp9_cuvid   | Google VP9                                |
```
