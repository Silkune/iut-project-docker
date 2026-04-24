FROM eclipse-temurin:25-jdk AS builder

WORKDIR /app

COPY . .

RUN ./gradlew build -x test --no-daemon

FROM eclipse-temurin:25-jre

WORKDIR /app

COPY --from=builder /app/build/libs/app.jar ./app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
