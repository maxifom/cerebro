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

ENTRYPOINT ["bin/cerebro"]