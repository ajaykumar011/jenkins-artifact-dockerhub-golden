pipeline {
    agent any
    options {
        timestamps()
    }
    environment {
        IMAGE = "ajaykumar011/jenkins-artifact-s3-jfrog-dhub-golden"
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
                    // https://hub.docker.com/repository/docker/ajaykumar011/jenkins-artifact-s3-jfrog-dhub-golden
                    def container = image.run('-p 81:80')
                    def contport = container.port(80)
                    println image.id + " container is running at host port, " + contport
                    def resp = sh(returnStdout: true,
                                        script: """
                                                set +x
                                                curl -w "%{http_code}" -o /dev/null -s \
                                                http://\"${contport}\"
                                                """
                                        ).trim()
                    if ( resp == "200" ) {
                        println "tutum hello world is alive and kicking!"
                        docker.withRegistry("${env.REGISTRY}", 'docker-hub') {
                            image.push("${GIT_HASH}")
                            if ( "${env.BRANCH_NAME}" == "master" ) {
                                image.push("LATEST")
                            }
                        }
                        currentBuild.result = "SUCCESS"
                    } else {
                        println "Humans are mortals."
                        currentBuild.result = "FAILURE"
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}