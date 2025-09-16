pipeline {
    agent any
    tools{
        maven 'maven'
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/vivekshet1495/devops.git'
            }
        }
        stage("Build"){
            steps{
                sh 'mvn install'
            }
        }
        stage("Build Image"){
            steps{
                sh 'docker build . -f Dockerfile -t godspeed95/devops:latest'
            }
        }
        stage("Image Push"){
            steps{
                sh 'docker push godspeed95/devops:latest'
            }
        }
        }
    }

