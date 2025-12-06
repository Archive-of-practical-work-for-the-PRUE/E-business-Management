FROM openjdk:26-ea-oracle AS builder

WORKDIR /app

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

RUN chmod +x ./mvnw

RUN ./mvnw dependency:go-offline -B

COPY src/ src/

RUN ./mvnw clean package -DskipTests

FROM openjdk:26-ea-oracle

WORKDIR /app

COPY --from=builder /app/target/project2-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]