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
                    //https://hub.docker.com/repository/docker/ajaykumar011/jenkins-artifact-s3-jfrog-dhub-golden
                    //def container = image.run('-p 81:80 -v app:/var/www/html')
                    def container = image.run('-p 80')
                    contport = container.port(80)
                    println image.id + " container is running at host port " + contport
                    println contport 
                    writeFile(file: 'commandResult', text: contport)
                    // sh "ls -l"
                    // sh "cat commandResult.txt"
                    // def resp = sh(returnStdout: true, script: "curl -w %{http_code} -o /dev/null -s http://$contport")

                    // sh "${contport} > commandResult"
                    env.curlurl = readFile('commandResult').trim()
                    //echo ${env.curlurl}
                }
            }
        }

        stage('Stage-Two') {
            steps {
                script {

                    echo "I am inside Stage -Two"
                    sh "echo ${env.curlurl}"
                    echo "LS = ${env.curlurl}"

                    
                    env.resp = sh(script:'curl -w %{http_code} -o /dev/null -s http://${env.curlurl}', returnStdout: true).trim()
                    echo "status = ${env.resp}"
                    // or if you access env variable in the shell command
                    sh 'echo $status'

                    if (env.resp == '200') {
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




//                     if ( resp == "200" ) {
//                         println "tutum hello world is alive and kicking!"
//                         docker.withRegistry("${env.REGISTRY}", 'docker-hub') {
//                             image.push("${GIT_HASH}")
//                             if ( "${env.BRANCH_NAME}" == "master" ) {
//                                 image.push("LATEST")
//                             }
//                         }
//                         currentBuild.result = "SUCCESS"
//                     } else {
//                         println "Humans are mortals."
//                         currentBuild.result = "FAILURE"
//                     }
//                 }
//             }
//         }
//     }
//     post {
//         always {
//             echo "Cleaning workspace"
//             //cleanWs()
//         }
//     }
// }

// pipeline {
//     agent any

//     environment{
//         CHECK_URL = "https://stackoverflow.com"
//         CMD = "curl --write-out %{http_code} --silent --output /dev/null ${CHECK_URL}"

//     }

//     stages {
//         stage('Stage-One') {
//             steps {
//                 script{
//                     sh "${CMD} > commandResult"
//                     env.status = readFile('commandResult').trim()
//                 }
//             }
//         }
//         stage('Stage-Two') {
//             steps {
//                 script {
//                     sh "echo ${env.status}"
//                     if (env.status == '200') {
//                         currentBuild.result = "SUCCESS"
//                     }
//                     else {
//                         currentBuild.result = "FAILURE"
//                     }
//                 }
//             }
//         }
//     }
// }













// // In Shell/Batch Script
// // In Shell script we can use environment variables using $Key or ${Key}. 
// // Similarly in batch we can use %Key% to access Environment Variables.

// // def buildJobArray = []   //local variable

// // buildJobArray = []  // Global variable