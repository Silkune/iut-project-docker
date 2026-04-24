FROM eclipse-temurin:25-jdk AS builder

WORKDIR /app

COPY . .

RUN ./gradlew build -x test --no-daemon

FROM eclipse-temurin:25 AS jre-build

RUN $JAVA_HOME/bin/jlink \
    --add-modules java.base,java.naming,java.logging,java.management,java.security.jgss,java.desktop,java.xml,java.instrument \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime

FROM debian:bookworm-slim

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY --from=jre-build /javaruntime $JAVA_HOME

WORKDIR /app

COPY --from=builder /app/build/libs/app.jar ./app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
