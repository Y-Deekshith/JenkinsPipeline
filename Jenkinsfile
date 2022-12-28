pipeline {
    agent none 
    stages {
        stage('Cloning git repo') {
            steps {
                // echo 'Hello, Maven'
                sh 'git clone https://github.com/aws-samples/eb-tomcat-snakes.git deegit'
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