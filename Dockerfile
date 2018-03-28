FROM stackexchange/bosun:0.6.0-pre
MAINTAINER PaladinTyrion <paladintyrion@gmail.com>

ENV VERSION 0.7.0-dev
ENV BOSUN_HOME /bosun
ENV SCOLLECTOR_HOME /scollector
ENV TSDBRELAY_HOME /tsdbrelay
ENV GOPATH /gobuild
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
ENV GO_PACKAGE go1.10.linux-amd64.tar.gz
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

RUN set -x \
    && apt-get update \
    && apt-get install -yq --no-install-recommends apt-utils \
    && set +x

RUN set -x \
    && apt-get install -yq dialog \
    && set +x

RUN set -x \
    && apt-get install -yq procps mlocate wget git tzdata \
    && dpkg-reconfigure -f noninteractive tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get clean \
    && wget --progress=bar:force -O ${GO_PACKAGE} "https://dl.google.com/go/${GO_PACKAGE}" \
    && tar -C /usr/local -xzf ${GO_PACKAGE} \
    && rm -fr ${GO_PACKAGE} \
    && go version \
    && set +x

# install the latest bosun scollector tsdbrelay
RUN set -x \
    && go get -u bosun.org/cmd/bosun \
    && cd $GOPATH/src/bosun.org/build \
    && go build -v -work build.go \
    && ./build -esv5 \
    && ls $GOPATH/bin \
    && mv $GOPATH/bin/bosun $BOSUN_HOME/bosun \
    && $BOSUN_HOME/bosun -version \
    && mv $GOPATH/bin/scollector $SCOLLECTOR_HOME/scollector \
    && $SCOLLECTOR_HOME/scollector -version \
    && mv $GOPATH/bin/tsdbrelay $TSDBRELAY_HOME/tsdbrelay \
    && $TSDBRELAY_HOME/tsdbrelay -version \
    && apt-get remove -y --purge wget git dialog apt-utils \
    && apt-get autoremove -y \
    && set +x

ENTRYPOINT ["/usr/bin/supervisord"]
