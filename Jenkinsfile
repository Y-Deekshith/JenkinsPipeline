pipeline {
    agent any 
    stages {
        stage('Start stage') {
            steps {
                echo 'Hello, Jenkins'
            }
        }
        stage('Build the code') {
            steps {
                sh 'ls -al && rm -rf *.war'
                sh 'bash build.sh'
                sh 'mv *.war ROOT${BUILD_NUMBER}.war' 
                sh 'ls -al'
            }
        }
        stage('Uploading Artifact to cloud') {
            steps {
                sh 'aws s3 ls'
                echo "${BUILD_NUMBER}"
                s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'*.war', bucket:'dees3devops', path:'*.war')
            }
        }
    }
}
