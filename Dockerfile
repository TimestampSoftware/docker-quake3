FROM alpine:3.10

RUN apk add --no-cache curl git make unzip
RUN apk add --no-cache build-base

RUN mkdir -p /opt/ioquake3 && addgroup ioquake3 && \
	adduser -h /ioquake3 -s /bin/false -G ioquake3 -D ioquake3 && \
	chown -R ioquake3:ioquake3 /ioquake3

RUN apk add --no-cache bash

USER ioquake3

RUN curl https://raw.githubusercontent.com/ioquake/ioq3/master/misc/linux/server_compile.sh \
	-o /ioquake3/server_compile.sh

RUN curl https://raw.githubusercontent.com/ioquake/ioq3/master/misc/linux/start_server.sh \
	-o /ioquake3/start_server.sh

RUN cd /ioquake3/ && chmod +x ./server_compile.sh && \
	yes | ./server_compile.sh

COPY ./baseq3 /ioquake3/ioquake3/baseq3

RUN chmod +x /ioquake3/start_server.sh

ENTRYPOINT ["/ioquake3/start_server.sh"]
