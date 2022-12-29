pipeline {
        environment {
        registry = 'deekshithy/dockerfiles'
        registryCredential = 'dockerhub_id'
        // dockerSwarmManager = '10.40.1.26:2375'
        // dockerhost = '10.40.1.26'
        dockerImage = ''
        PACKER_BUILD = 'NO'
        TERRAFORM = 'YES'
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
        stage('Push our image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }
        stage('Performing packer build') {
            when {
                expression {
                    env.PACKER_BUILD == 'YES'
                }
            }
            steps{
                sh 'packer build -var-file packer-vars.json packer.json | tee output.txt'
                sh "tail -2 output.txt | head -2 | awk 'match(\$0, /ami-.*/) { print substr(\$0, RSTART, RLENGTH) }' > ami.txt"
                sh "echo \$(cat ami.txt) > ami.txt"
                script{
                    def AMIID = readFile('ami.txt').trim()
                    sh "echo variable \\\"imagename\\\" { default = \\\"$AMIID\\\" } >> variables.tf"
                }
            }
        }
        stage('Default packer ami') {
            when {
                expression {
                    env.PACKER_BUILD == 'NO'
                }
            }
            steps{
                script{
                    def AMIID = 'ami-0bf036b289f524a6e'
                    sh "echo variable \\\"imagename\\\" { default = \\\"$AMIID\\\" } >> variables.tf"
                }
            }
        }
        stage('Terraform validate and plan') {
            when {
                expression {
                    env.TERRAFORM == 'YES'
                }
            }
            steps{
                script{
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform validate and apply') {
            when {
                expression {
                    env.TERRAFORM == 'YES'
                }
            }
            steps{
                script{
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
                    sh 'terraform state list'
                }
            }
        }
        stage('Terraform Destroy infra') {
            when {
                expression {
                    env.TERRAFORM == 'NO'
                }
            }
            steps{
                script{
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
        stage('Deploying docker image to infra') {
            steps{
                script{
                    def DOCKER_HOST = readFile('publicip.txt').trim()
                    sh "docker -H tcp://$DOCKER_HOST:2375 run --rm -dit --name dee -p 8080:8080 deekshithy/dockerfiles:$BUILD_NUMBER"
                }
            }
        } 
    }
}
