#!/usr/bin/env groovy

def call(String image_name, String K8S_CRED_ID, String minikube_server, String deployment_file) {
    sh "sed -i 's|${username}/${image_name}:.*|${username}/${image_name}:${BUILD_ID}|g' ${deployment_file}"
    
    withCredentials([file(credentialsId: "${K8S_CRED_ID}", variable: 'KUBECONFIG')]) {
        sh "export KUBECONFIG=${KUBECONFIG} && kubectl --server ${minikube_server}  --insecure-skip-tls-verify=true apply -f ${deployment_file}"
    }
}