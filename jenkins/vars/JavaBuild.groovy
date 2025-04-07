#!/usr/bin/env groovy

def call() {
    sh 'chmod +x gradlew'
    sh './gradlew tasks && ./gradlew build'
}