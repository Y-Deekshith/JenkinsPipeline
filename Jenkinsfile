pipeline {
        environment {
        registry = 'deekshithy/dockerfiles'
        registryCredential = 'deekshithy'
        // dockerSwarmManager = '10.40.1.26:2375'
        // dockerhost = '10.40.1.26'
        dockerImage = ''
        }
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
                s3Upload consoleLogLevel: 'INFO', dontSetBuildResultOnFailure: false, dontWaitForConcurrentBuildCompletion: false, entries: [[bucket: 'dees3devops', excludedFile: '', flatten: false, gzipFiles: false, keepForever: false, managedArtifacts: false, noUploadOnFailure: true, selectedRegion: 'us-east-1', showDirectlyInBrowser: false, sourceFile: '*.war', storageClass: 'STANDARD_IA', uploadFromSlave: false, useServerSideEncryption: false]], pluginFailureResultConstraint: 'FAILURE', profileName: 'dees3devops', userMetadata: []
            }
        }
        stage('Building our image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    }
                }
        }
        stage('Deploy our image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }        
    }
}
