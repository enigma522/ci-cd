pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/your-repo-name'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        CONTAINER_NAME = 'my_container'
        APP_PORT = '8080'
        HOST_PORT = '80'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                git 'https://github.com/your-repo.git'
            }
        }

        stage('Build and Test') {
            steps {
                echo 'Building and testing the project using Maven...'
                sh 'mvn clean package' 
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${DOCKER_IMAGE}:latest"
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                }
            }
        }

        stage('Deploy on VM') {
            steps {
                echo 'Deploying the container on the VM...'
                script {
                    sh '''
                        echo "Stopping and removing old container..."
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true

                        echo "Pulling latest Docker image..."
                        docker pull ${DOCKER_IMAGE}:latest

                        echo "Cleaning up old images..."
                        docker image prune -f || true

                        echo "Running new container..."
                        docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${APP_PORT} ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed. Check logs for details.'
        }
    }
}
