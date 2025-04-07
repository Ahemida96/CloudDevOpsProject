#!/usr/bin/env groovy

def call() {
    withSonarQubeEnv('sonarqube') {
        sh './gradlew sonar'
    }
}