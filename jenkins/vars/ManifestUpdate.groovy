#!/usr/bin/env groovy

def call(String image_name, String K8S_CRED_ID, String minikube_server, String deployment_file) {
    sh "sed -i 's|${username}/${image_name}:.*|${username}/${image_name}:${BUILD_ID}|g' ${deployment_file}"
}

def call (Map config) {
    def image_name = config.image_name
    // def github-credentials = config.github_credentials
    def manifestFile = config.manifestFile
    def manifestDir = config.manifestDir
    def gitUsername = config.username
    def gitEmail = config.email
    // def manifest_repo = config.manifest_repo

    if (!fileExists("${manifestDir}/${manifestFile}")) {
        error("Manifest file ${manifestDir}/${manifestFile} not found!")
    }
    dir("${manifestDir}") {
        sh "sed -i 's|${username}/${image_name}:.*|${username}/${image_name}:${BUILD_ID}|g' ${manifestFile}"
    }

    // git branch: 'main', url: "${manifest_repo}", credentialsId: "${github-credentials}"
    sh "git config user.name ${gitUsername}"
    sh "git config user.email ${gitEmail}"
    sh "git add ${manifestFile}"
    sh "git commit -m 'Updated image to ${username}/${image_name}:${BUILD_ID}'"
    sh "git push origin master"
}