FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to Tomcat
COPY target/*.war
# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
