FROM openjdk:23-jdk-slim

WORKDIR /app

COPY target/hello-spring-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
