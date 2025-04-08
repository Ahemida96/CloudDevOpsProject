#!/usr/bin/env groovy

def call(String imageName, String dockerHubCredentialsID) {
    withCredentials([usernamePassword(credentialsId: "${dockerHubCredentialsID}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh """
            echo ${imageName}
            docker login -u ${USERNAME} -p ${PASSWORD}
            docker build -t ${USERNAME}/${imageName}:${env.BUILD_ID} .
            docker push ${USERNAME}/${imageName}:${env.BUILD_ID}
            docker rmi ${USERNAME}/${imageName}:${env.BUILD_ID}
        """
    }
}