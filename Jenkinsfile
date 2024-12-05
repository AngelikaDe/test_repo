pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Симуляция процесса сборки
                echo 'Building the project...'
            }
            post {
                always {
                    script {
                        echo 'Always cleaning up after Build stage...'
                    }
                }
                cleanup {
                    script {
                        echo 'Cleaning up resources for Build stage...'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                // Запуск тестов
                echo 'Running tests...'
            }
        }
        stage('Report') {
            steps {
                // Генерация отчёта
                echo 'Generating test report...'
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished!'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
