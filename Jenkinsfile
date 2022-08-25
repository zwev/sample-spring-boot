pipeline {
    agent any
        environment {
        ENV_DOCKER = credentials('dockerhub')
        DOCKERIMAGE = "toomanycooks/junkrepo"
        EKS_CLUSTER_NAME = "sre-lab"
        SONAR_TOKEN = credentials('sonartoken')
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
                sh 'sonar-scanner'                
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
                            dockerImage.push("$BUILD_ID")
                            dockerImage.push('latest')
                    }
                }
                
            }
        }
        stage('Deploy App') {
            agent {
                docker {
                    image 'jshimko/kube-tools-aws:3.8.1'
                    args '-u root --privileged'
                }
            }
            steps {
                sh 'echo deploy to kubernetes' 
                
                withAWS(credentials:'aws-credentials') {
                    sh 'aws eks update-kubeconfig --name amazing-mushroom-1661437635'
                    sh 'kubectl get all'
                    sh 'chmod +x deployment-status.sh && ./deployment-status.sh'
                    sh "kubectl set image deployment sample-spring-boot -n ari-ochoa springboot-sample=$ENV_DOCKER_USR/$DOCKERIMAGE:$BUILD_ID"
                }
            }
    }

}
}