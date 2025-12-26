FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/ManjitSharma963/katariastoneworldbackend.git .

RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
