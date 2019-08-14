FROM docker:dind as builder
LABEL builder=true
MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

#RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
#RUN apk add --update docker openrc
RUN service docker start
RUN docker run --rm --entrypoint cat infoblox/dnstools /bin/dnsperf > /bin/dnsperf
RUN docker run --rm --entrypoint cat infoblox/dnstools /bin/resperf > /bin/resperf
RUN docker run --rm --entrypoint cat infoblox/dnstools /bin/queryperf > /bin/queryperf

FROM alpine:latest
ENV PS1="debugcontainer# "

COPY --from=builder /bin/dnsperf /bin
COPY --from=builder /bin/resperf /bin
COPY --from=builder /bin/queryperf /bin

RUN apk add --update \
      # Basic shell stuff
      bash \
      bash-completion \
      readline \
      busybox-extras \
      grep \
      gawk \
      tree \
      sed \
      # Interacting with the networks
      curl \
      wget \
      openssl \
      bind-tools \
      curl \
      tcptraceroute \ 
      jq \
      drill \
      nmap \
      netcat-openbsd \
      socat \
      tcpdump \
      # Monitoring / Shell tools
      htop \
      mc \
      # Development tools
      libcrypto1.0 \
      g++ \
      gcc \
      python3 \
      unixodbc-dev \
      vim \
      elinks \
      tmux \
      git \
      tig \
      mysql-client \
      ca-certificates \
      python3-dev \
      alpine-sdk \
      freetds-dev \
    && rm -rf /var/cache/apk/* \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade Cython --install-option="--no-cython-compile" \
    && pip3 install --upgrade setuptools \
    && pip3 install mssql-cli \
    && rm -rf /var/cache/* \
    && rm -rf /root/.cache/*


ENTRYPOINT [ "bash" ]
