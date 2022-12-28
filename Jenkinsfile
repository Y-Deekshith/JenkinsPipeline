pipeline {
    agent none 
    stages {
        stage('Cloning git repo') {
            steps {
                echo 'Hello, Jenkins'
                sh 'ls -al'
            }
        }
        stage('Build the code') {
            steps {
                sh 'ls -al && rm -rf *.war'
                sh 'bash build.sh'
                sh 'ls -al'
            }
        }
    }
}