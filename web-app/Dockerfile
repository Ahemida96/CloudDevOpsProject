# Build Stage
FROM gradle:7.6.1-jdk17-alpine AS builder

WORKDIR /app

# Copy Gradle configs (for caching)
COPY build.gradle gradlew settings.gradle ./
COPY gradle ./gradle

# Download dependencies (cached unless build.gradle changes)
RUN ./gradlew dependencies --no-daemon

# RUN chmod +x gradlew
COPY src ./src
RUN ./gradlew build --no-daemon

# Use an official OpenJDK image, The final stage only needs JRE (not JDK) to run the JAR.
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built JAR file
COPY --from=builder /app/build/libs/*.jar app.jar 

# Expose port
EXPOSE 8081

# Run the application
CMD ["java", "-jar", "app.jar"]