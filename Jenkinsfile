pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = 'herber177/node-backend-villegas'
        BACKUP_IMAGE = 'herber177/db-backup'
    }

    stages {

        stage('Clonar repositorio') {
            steps {
                git branch: 'jenkins',
                    url: 'https://github.com/herber1775/examen_final_devops.git'
            }
        }

        stage('Construir imagen backend') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:latest -f docker/Dockerfile .'
            }
        }

        stage('Construir imagen backup') {
            steps {
                sh 'docker build -t ${BACKUP_IMAGE}:latest ./backup'
            }
        }

        stage('Publicar imagenes en Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push ${IMAGE_NAME}:latest'
                sh 'docker push ${BACKUP_IMAGE}:latest'
            }
        }

        stage('Desplegar en servidor') {
            steps {
                sh '''
                    docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        -v /codigo/villegas:/codigo/villegas \
                        -w /codigo/villegas \
                        docker:cli sh -c "
                            if [ -d examen_final_devops ]; then
                                cd examen_final_devops && git pull origin jenkins
                            else
                                apk add --no-cache git
                                git clone -b jenkins https://github.com/herber1775/examen_final_devops.git
                                cd examen_final_devops
                            fi
                            cd docker
                            docker compose down
                            docker compose pull
                            docker compose up -d
                            docker ps
                        "
                '''
            }
        }
    }

    post {
        success {
            echo 'Despliegue exitoso en /codigo/villegas'
        }
        failure {
            echo 'Error en el pipeline'
        }
    }
}
