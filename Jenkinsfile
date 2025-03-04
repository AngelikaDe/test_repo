pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Клонирование в folder1 (branch1)"
                    dir('folder1') {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: '*/branch1']],
                            userRemoteConfigs: [[
                                url: 'https://github.com/AngelikaDe/test_repo.git',
                                credentialsId: 'github_test'
                            ]]
                        ])
                    }
                    
                    echo "Клонирование в folder2 (branch2)"
                    dir('folder2') {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: '*/branch2']],
                            userRemoteConfigs: [[
                                url: 'https://github.com/AngelikaDe/test_repo.git',
                                credentialsId: 'github_test'
                            ]]
                        ])
                    }
                }
            }
        }
        stage('List Files') {
            steps {
                script {
                    echo "Содержимое folder1:"
                    sh 'ls -l folder1 || true'
                    echo "Содержимое folder2:"
                    sh 'ls -l folder2 || true'
                }
            }
        }
    }
}
