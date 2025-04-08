#!/usr/bin/env groovy

def call (Map config) {
    def image_name = config.image_name
    // def github-credentials = config.github_credentials
    def manifestFile = config.manifestFile
    def manifestDir = config.manifestDir
    def gitUsername = config.username
    def gitEmail = config.email
    def dockerhubUsername = config.dockerhub_username
    // def manifest_repo = config.manifest_repo

    if (!fileExists("${manifestDir}/${manifestFile}")) {
        error("Manifest file ${manifestDir}/${manifestFile} not found!")
    }
    dir("${manifestDir}") {
        sh "sed -i 's|${dockerhubUsername}/${image_name}:.*|${dockerhubUsername}/${image_name}:${BUILD_ID}|g' ${manifestFile}"
    }

    // git branch: 'main', url: "${manifest_repo}", credentialsId: "${github-credentials}"
    sh """
        git config --global user.name ${gitUsername}
        git config --global user.email ${gitEmail}
        git add ${manifestFile}
        git commit -m 'Updated image to ${dockerhubUsername}/${image_name}:${BUILD_ID}'
        git push origin master

    """
}