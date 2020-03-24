pipeline {
    environment {
        registry = "karlosarr/nginx-react-demo"
        registryCredential = 'dockerhub'
    }
    agent {
        label "swarm"
    }
    stages {
        // stage ('Install') {
        //     steps {
        //         checkout([
        //             $class: 'GitSCM',
        //             branches: [[name: '*/master']],
        //             doGenerateSubmoduleConfigurations: false,
        //             extensions: [],
        //             submoduleCfg: [],
        //             userRemoteConfigs: [[
        //                 credentialsId: 'github_karlosarr',
        //                 url: 'https://github.com/karlosarr/jaxitank-react-demo'
        //             ]]
        //         ])
        //     }
        // }
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
                // stage('Deploy for production') {
                //     when {
                //         branch 'master'
                //     }
                //     steps {
                //         script {
                //             sh 'mvn -DskipITs --settings ./maven/settings.xml clean package'
                //         }
                //         step([$class: 'TeamCollectResultsPostBuildAction'])
                //     }
                // }
            }
        }
        stage('Deploy for production') {
            when {
                branch 'master'
            }
            steps {
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
        // stage('Building image') {
        //     steps{
        //         script {
        //             dockerImage = docker.build registry + ":v1.0.$BUILD_NUMBER"
        //         }
        //     }
        // }
        // stage('Deploy Image') {
        //     steps{
        //         script {
        //             docker.withRegistry( '', registryCredential ) {
        //                 dockerImage.push()
        //             }
        //         }
        //     }
        // }
        // stage('Remove Unused docker image') {
        //     steps{
        //         sh "docker rmi $registry:v1.0.$BUILD_NUMBER"
        //     }
        // }
        stage('Clean') {
            steps {
                deleteDir()
            }
        }
    }
}
