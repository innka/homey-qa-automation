pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Repository downloaded successfully'
            }
        }

        stage('Environment') {
            steps {
                bat 'python --version'
                bat 'where robot'
            }
        }

        stage('Run UI Tests') {
            steps {
                bat 'robot --outputdir results\\IHM auto_test\\IHM'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/IHM/**/*',
                             allowEmptyArchive: true
        }

        success {
            echo 'All UI tests passed.'
        }

        failure {
            echo 'Some UI tests failed. Check the Robot Framework report.'
        }
    }
}