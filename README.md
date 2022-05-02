# BB60C Dockerfile and Example

A Dockerfile for using the [Signal Hound BB60C](https://signalhound.com/products/bb60c/) USB spectrum analyzer SDK on Linux (more specifically Ubuntu 20.04, but it should work fine on any Debian-based Linux distribution.)

## Building

Install Docker according to the instructions [here](https://docs.docker.com/engine/install/ubuntu/) and to the post-installation tasks [here](https://docs.docker.com/engine/install/linux-postinstall/). Then build the BB60C image:

```bash
$ git clone https://github.com/herrameise/bb60c-docker
$ cd bb60c-docker
bb60c-docker/$ docker build -t herrameise:bb60c .
```

## Running

Plug the Signal Hound BB60C into your computer and note which the USB bus/device ID. The display name is usually `Cypress FX3`.

```bash
bb60c-docker/$ lsusb
[...]
Bus 004 Device 002: ID 2817:0005 Cypress FX3
[...]
```

Then create a Docker container from the `herrameise:bb60c` image, passing in the Signal Hounds USB information as well as the `examples/` directory from the repository. Unfortunately, Docker does not allow mounting host directories via relative path, so you will need to specify the full path for the `examples/` directory in the `bb60c-docker` repository. In my case, I had cloned the repository into `~/Downloads/`, so the full path would be `/home/$USER/Downloads/bb60c-docker/examples/`.

```bash
bb60c-docker/$ docker run \
    -it \
    --device=/dev/bus/usb/004/002 \
    -v /home/$USER/Downloads/bb60c-docker/examples:/root/examples \
    herrameise:bb60c \
    bash
````

Once in the container, navigate to `/root/examples` and build/run the desired examples:

```bash
root@26a665115141:~# cd /root/examples/
root@26a665115141:~/examples# make
g++ device_info.cpp -Wall -lbb_api -o device_info.out
root@26a665115141:~/examples# ./device_info.out 
[*] API Version: 4.3.4
[*] attempting to open device with serial number 12345678
[*] device opened successfully
[*] device info:
    device type: BB60C
    firmware version: 8
    device internal temperature:    44.125000 C
    device voltage:                 4.710000 V
    device current draw:            1026.000000 mA
```

The example currently in the repository (`device_info`) is copied directly from the Signal Hound SDK, but I may add others later as I explore the API.
