FROM openjdk:17-jdk-slim AS builder
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
ENV GRADLE_OPTS="-Xmx512m"
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

FROM openjdk:17-jdk-slim
COPY --from=builder build/libs/*.jar app.jar

# argument로 받은 ENVIRONMENT 값을 SPRING_PROFILES_ACTIVE에 적용
ENV SPRING_PROFILES_ACTIVE=dev

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]