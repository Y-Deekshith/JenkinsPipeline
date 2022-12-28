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
                s3Upload(file:'ROOT${BUILD_NUMBER}.war', bucket:'dees3devops', path:'/ROOT${BUILD_NUMBER}.war')
            }
        }
    }
}
