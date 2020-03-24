pipeline {
    environment {
        registry = "karlosarr/nginx-react-demo"
        registryCredential = 'dockerhub'
    }
    agent {
        label "swarm"
    }
    stages {
        stage('preparing docker') {
            agent {
                docker { 
                    image 'node:12.16.1'
                    args '--entrypoint=\'\' -v ${PWD}:/usr/src/app -w /usr/src/app'
                    reuseNode true
                }
            }
            stages {
                stage ('Install') {
                    steps {
                        script {
                            sh 'npm i'
                        }
                    }
                }
                stage ('Analyzing with SonarQube') {
                    steps {
                        sh 'npm run build'
                    }
                }
            }
        }
        stage('Deploy for production') {
            when {
                branch 'master'
            }
            stages {
                stage('Building image') {
                    steps{
                        script {
                            dockerImage = docker.build registry + ":v1.0.$BUILD_NUMBER"
                        }
                    }
                }
                stage('Deploy Image') {
                    steps{
                        script {
                            docker.withRegistry( '', registryCredential ) {
                                dockerImage.push()
                            }
                        }
                    }
                }
                stage('Remove Unused docker image') {
                    steps{
                        sh "docker rmi $registry:v1.0.$BUILD_NUMBER"
                    }
                }
            }
        }
        stage('Clean') {
            steps {
                deleteDir()
            }
        }
    }
}
