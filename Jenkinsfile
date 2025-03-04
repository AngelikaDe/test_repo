pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Начинаем клонирование в folder1"
                    dir('folder1') {
                        sh 'pwd'
                        git branch: 'branch1',
                            credentialsId: 'github_test',
                            url: 'https://github.com/AngelikaDe/test_repo.git'
                    }
                    echo "Клонирование branch1 завершено"

                    echo "Начинаем клонирование в folder2"
                    dir('folder2') {
                        sh 'pwd'
                        git branch: 'branch2',
                            credentialsId: 'github_test',
                            url: 'https://github.com/AngelikaDe/test_repo.git'
                    }
                    echo "Клонирование branch2 завершено"
                }
            }
        }
        stage('List Files') {
            steps {
                script {
                    echo "Вывод содержимого folder1"
                    sh 'ls -l folder1 || true'
                    echo "Вывод содержимого folder2"
                    sh 'ls -l folder2 || true'
                }
            }
        }
    }
}
