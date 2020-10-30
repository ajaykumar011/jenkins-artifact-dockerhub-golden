pipeline {
    agent any
    options {
        timestamps()
    }

    environment {
        IMAGE = "ajaykumar011/jenkins-artifact-dockerhub-golden"
        REGISTRY = "https://registry.hub.docker.com"
    }
    stages {
        stage('prep') {
            steps {
                script {
                    env.GIT_HASH = sh(
                        script: "git show --oneline | head -1 | cut -d' ' -f1",
                        returnStdout: true
                    ).trim()
                }
            }
        }
        stage('build') {
            steps {
                script {
                    image = docker.build("${IMAGE}")
                    println "Newly generated image, " + image.id
                }
            }
        }
        stage('test') {
            steps {
                script {
                    //https://hub.docker.com/repository/docker/ajaykumar011/jenkins-artifact-dockerhub-golden
                    //def container = image.run('-p 81:80 -v app:/var/www/html') #this for specfic port and volumne
                    def container = image.run('-p 80')
                    def contport = container.port(80)
                    println image.id + " container is running at host port " + contport
                    // withEnv(['VAR1=VALUE ONE',"VAR2=${contport}"]) {
                    //     def result = sh(script: 'curl -w %{http_code} -o /dev/null -s "http://${VAR2}"', returnStdout: true)
                    //     echo result
                    }
               }
            }


        stage('Push to Docker hub') {
            steps {
                script {
                        println "Docker Container is alive and ready to push to Docker hub!"
                        docker.withRegistry("${env.REGISTRY}", 'docker-hub') {
                            image.push("${GIT_HASH}")
                            if ( "${env.BRANCH_NAME}" == "master" ) {
                                image.push("LATEST")
                            }
                        }
                        currentBuild.result = "SUCCESS"
                    }
                }
            } 
        stage('Push to Jfrog') {
            steps {
                script {
                        println "Docker Container is alive and ready to push to Jfrog!"
                        docker.withRegistry("${env.REGISTRY}", 'docker-hub') {
                            image.push("${GIT_HASH}")
                            if ( "${env.BRANCH_NAME}" == "master" ) {
                                image.push("LATEST")
                            }
                        }
                        currentBuild.result = "SUCCESS"
                }
            }
        }  
    }
    post {
        always {
            echo "Cleaning workspace"
            cleanWs()
        }
    }
}