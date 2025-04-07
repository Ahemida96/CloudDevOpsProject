#!/usr/bin/env groovy

def call(String image_name, String dockerHubCredentialsID) {
    withCredentials([usernamePassword(credentialsId: "${dockerHubCredentialsID}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh "docker login -u ${USERNAME} -p ${PASSWORD}"
        sh 'docker build -t ${USERNAME}/${image_name}:${BUILD_ID} .'
        sh 'docker push ${USERNAME}/${image_name}:${BUILD_ID}'
        sh 'docker rmi ${USERNAME}/${image_name}:${BUILD_ID}'
    }
}