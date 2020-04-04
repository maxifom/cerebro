#FROM openjdk:11-jre-slim
#
#ENV CEREBRO_VERSION 0.8.6
#
#RUN  apt-get update \
# && apt-get install -y wget \
# && rm -rf /var/lib/apt/lists/* \
# && mkdir -p /opt/cerebro/logs \
# && wget -qO- https://github.com/lmenezes/cerebro/releases/download/v${CEREBRO_VERSION}/cerebro-${CEREBRO_VERSION}.tgz \
#  | tar xzv --strip-components 1 -C /opt/cerebro \
# && sed -i '/<appender-ref ref="FILE"\/>/d' /opt/cerebro/conf/logback.xml \
# && addgroup -gid 1000 cerebro \
# && adduser -gid 1000 -uid 1000 cerebro \
# && chown -R cerebro:cerebro /opt/cerebro
#
#
#
#
#WORKDIR /opt/cerebro
#EXPOSE 9000
#USER cerebro
#ENTRYPOINT [ "/opt/cerebro/bin/cerebro" ]


FROM openjdk:11-slim
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
# SBT
ENV SBT_VERSION "1.3.9"
ENV SBT_HOME /usr/sbt
ENV PATH $PATH:$SBT_HOME/bin
RUN curl -sL --retry 3 "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" \
  | gunzip \
  | tar -x -C /usr/
EXPOSE 9000
WORKDIR /usr/cerebro

# CEREBRO
ADD . /usr/src/cerebro/
RUN cd /usr/src/cerebro && sbt stage \
 && cp -r target/universal/stage/* /usr/cerebro/ \
 && rm -rf /usr/src/cerebro /root/.ivy2

CMD ["bin/cerebro"]