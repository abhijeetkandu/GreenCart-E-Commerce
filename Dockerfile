# ---------- STEP 1: BUILD WAR ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy all project files
COPY . .

# Build the WAR file
RUN mvn clean package


# ---------- STEP 2: RUN ON TOMCAT ----------
FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
