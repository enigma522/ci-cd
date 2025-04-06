pipeline {
    agent any
    stages {
        stage('Build and Test') {
            steps {
                echo 'Building and testing the project using Maven...'
                sh 'mvn clean package' 
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
