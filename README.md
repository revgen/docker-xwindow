# Base docker image with XWindow setup and RDP access

The docker image contains [fluxbox](https://fluxbox.org/), [xterm](https://en.wikipedia.org/wiki/Xterm), and [xrdp](https://en.wikipedia.org/wiki/Xrdp).

The XWindows is not starting automatically, it will be started when [RDP](https://en.wikipedia.org/wiki/Remote_Desktop_Protocol) session will be started.

![RDP session](https://github.com/revgen/docker-xwindow/blob/master/screenshot-macos.png?raw=true)

## Usage

```bash
docker run -it --rm -e PASSWORD=123456 -p 3389:3389 rev9en/xwindow
```

Now, you can use a reguler RDP cliet to conect to the localhost (default port: 3389) with a username **user** and a password **123456**.

## Build locally

```bash
make build
```

## Links

* [Docker image source code](https://github.com/revgen/docker-xwindow)
* [Docker hub page](https://hub.docker.com/r/rev9en/xwindow)
* [Microsoft Remote Desktop Client for MacOS](https://apps.apple.com/us/app/windows-app/id1295203466?mt=12)
* [Remmina - RDP client for Linux](https://remmina.org/)