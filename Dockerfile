FROM podbox/java8

# --------------------------------------------------------------------- tcnative
ENV APR_VERSION 1.5.1
ENV TCNATIVE_VERSION 1.1.33

RUN apt-get update && apt-get install -yq cpp gcc make libssl-dev libpcre++-dev zlib1g-dev \

 && (curl -L http://mirrors.ibiblio.org/apache/apr/apr-$APR_VERSION.tar.gz | gunzip -c | tar x) \
 && cd apr-$APR_VERSION \
 && ./configure \
 && make install \

 && (curl -L http://mirrors.ibiblio.org/apache/tomcat/tomcat-connectors/native/$TCNATIVE_VERSION/source/tomcat-native-$TCNATIVE_VERSION-src.tar.gz | gunzip -c | tar x) \
 && cd tomcat-native-$TCNATIVE_VERSION-src/jni/native \
 && ./configure --with-java-home=/jdk --with-apr=/usr/local/apr --prefix=/usr \
 && make install \

 && apt-get autoremove -y cpp gcc make libssl-dev libpcre++-dev zlib1g-dev \
 && apt-get clean purge \
 && rm -fR /tmp/* /apr-* /tomcat-native-*

# ---------------------------------------------------------------------- tomcat8
ENV TOMCAT_VERSION 8.0.21

RUN (curl -L http://mirrors.ibiblio.org/apache/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz | gunzip -c | tar x) \
 && mv apache-tomcat-$TOMCAT_VERSION /apache-tomcat \
 && rm -fR /apache-tomcat/webapps/* \

 && sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="X-Forwarded-Proto"\/><\/Host>/' /apache-tomcat/conf/server.xml

ADD context.xml /apache-tomcat/conf/

EXPOSE 8080
CMD ["/apache-tomcat/bin/catalina.sh", "run", "-security"]
