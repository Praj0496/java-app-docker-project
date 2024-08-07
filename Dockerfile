#Base image
FROM tomcat:8.5

# Remove the default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into Tomcat's webapps directory
COPY ./var/lib/jenkins/workspace/Jenkins_pipeline_job/web/target/java-app-0.1.0.war /usr/local/tomcat/webapps/

EXPOSE 8080

WORKDIR /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]