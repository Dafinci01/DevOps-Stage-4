# Dockerfile for Users API (Java/Spring Boot)
# Assumes you have already built a jar file in the 'target' folder.
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
