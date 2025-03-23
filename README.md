# Base docker image with XWindow setup and RDP access



This is a base docker image with Fluxbox SMTP Relay server based on [postfix](https://www.postfix.org/).

You can run a local smtp server which are pointed to the real private email provider.

_Tested on Gmail and Yahoo._

> **INPORTANT: SMTP server doesn't have any authentication layer. Please do not put it into the public network.**

## Usage

```bash
docker run -it --rm -e PASSWORD=123456 -p 3389:3389 rev9en/xwindow
```

After that a regular smtp server will be available on localhost port 25.


## Test

1. Start ```rev9en/smtpserver``` docker image (see: [usage section](#usage))
2. Run test script to send a test email via SMTP server on localhost port 25: ```python send-test-email.py <sender-email@sample.com>```

## Build locally

```bash
make build
```

## Links

* [Docker image source code](https://github.com/revgen/docker-smtpserver)
* [Docker hub page](https://hub.docker.com/r/rev9en/smtpserver)
* [Docker alpine official page](https://hub.docker.com/_/alpine)
* [Postfix Documentation](https://www.postfix.org/documentation.html)
* [How to configure gmail server as a relayhost in Postfix?](https://access.redhat.com/solutions/3201002)
* [Postfix relay through Yahoo!](https://www.webcodegeeks.com/web-servers/postfix-relay-through-yahoo-ssl/)
