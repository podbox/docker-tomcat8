FROM podbox/java8

# ---------------------------------------------------------------------- tomcat8
ENV TOMCAT_VERSION 8.0.20

RUN (curl -L http://mirrors.ibiblio.org/apache/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz | gunzip -c | tar x) \
 && mv apache-tomcat-$TOMCAT_VERSION /apache-tomcat \
 && rm -fR /apache-tomcat/webapps/* \

 && sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="X-Forwarded-Proto" \/><\/Host>/' /apache-tomcat/conf/server.xml


EXPOSE 8080
CMD ["/apache-tomcat/bin/catalina.sh", "run"]
