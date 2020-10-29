pipeline {
    agent any

    environment{
        CHECK_URL = "https://stackoverflow.com"
        CMD = "curl --write-out %{http_code} --silent --output /dev/null ${CHECK_URL}"

    }

    stages {
        stage('Stage-One') {
            steps {
                script{
                    sh "${CMD} > commandResult"
                    env.status = readFile('commandResult').trim()
                }
            }
        }
        stage('Stage-Two') {
            steps {
                script {
                    sh "echo ${env.status}"
                    if (env.status == '200') {
                        currentBuild.result = "SUCCESS"
                    }
                    else {
                        currentBuild.result = "FAILURE"
                    }
                }
            }
        }
    }
}