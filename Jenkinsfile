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
                    script{
                        echo 'Cleaning up...'
                    }
                }
                cleanup {
                    script{
                        echo 'Cleaning up...'
                    }
                }
            }
        }
        }
        stage('Test') {
            steps {
                // Запуск тестов
                echo 'Running tests...'
                // Пример запуска тестов через shell-скрипт
                sh './run-tests.sh'
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
