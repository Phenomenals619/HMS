# Use an official Maven image with Java 17
FROM maven:3.9.6-eclipse-temurin-17 as builder

# Set working directory
WORKDIR /app

# Copy necessary files
COPY pom.xml .
COPY mvnw mvnw.cmd ./
COPY .mvn .mvn
COPY src ./src

# Give execution permissions (fixes "chmod" error)
RUN chmod +x mvnw

# Build the application (skip tests for faster build)
RUN ./mvnw clean package -DskipTests

# Use Tomcat as runtime
FROM tomcat:9-jdk17

# Copy the built WAR file from the builder stage
COPY --from=builder /app/target/your-app.war /usr/local/tomcat/webapps/your-app.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
