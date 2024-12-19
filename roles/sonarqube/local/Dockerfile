FROM ubuntu:20.04

RUN apt update && \
    apt install -y openjdk-17-jdk unzip wget && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    SONARQUBE_VERSION=9.9.1.69595 \
    SONARQUBE_DIR=/opt/sonarqube/sonar

RUN groupadd -r sonarqube && useradd -r -g sonarqube -d /opt/sonarqube sonarqube

RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONARQUBE_VERSION.zip -O /tmp/sonarqube.zip && \
    unzip /tmp/sonarqube.zip -d /opt/sonarqube && \
    mv /opt/sonarqube/sonarqube-$SONARQUBE_VERSION $SONARQUBE_DIR && \
    rm /tmp/sonarqube.zip && \
    chown -R sonarqube:sonarqube /opt/sonarqube

USER sonarqube

EXPOSE 9000

CMD ["/opt/sonarqube/sonar/bin/linux-x86-64/sonar.sh", "console"]