pipeline {
    agent any
        environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "toomanycooks/junkrepo"
        EKS_CLUSTER_NAME = "sre-lab"
    }
    stages {
        stage('build') {
            agent {
                docker { image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
            }
        }
        stage('sonarqube') {
        agent {
            docker { image 'emeraldsquad/sonar-scanner:latest' } }
            steps {
                sh 'echo scanning!'
                
            }
        }
        stage('docker build') {
            steps {
                script {
                    echo "Building docker image!"
                    dockerImage = docker.build("toomanycooks/junkrepo:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('docker push') {
            agent any
                steps {
                    sh 'echo docker push!'
                script {
                    docker.withRegistry('', 'dockerhub') {
                        image.push("$BUILD_ID")
                        image.push('latest')
                    }
                }
                
            }
        }
        stage('Deploy App') {
            steps {
                sh 'echo deploy to kubernetes'               
            }
    }

}
}