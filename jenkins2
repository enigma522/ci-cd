pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'enigma522/springboot'
        CONTAINER_NAME = 'spring_container'
        APP_PORT = '8080'
        HOST_PORT = '80'
        DOCKER_CREDENTIALS_ID = '1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/enigma522/ci-cd.git'
            }
        }

        stage('Build and Test') {
            steps {
                echo 'Building and testing the project using Maven...'
                sh 'mvn clean package' 
            }
        }

        stage('Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                    }
                }
            }
		}

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${DOCKER_IMAGE}:latest"
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                sh "docker push ${DOCKER_IMAGE}:latest"
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

                        echo "Running new container..."
                        docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${APP_PORT} ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
        stage('Cleanup') {
            steps {
                sh 'docker logout'
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
