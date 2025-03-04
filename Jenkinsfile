pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    dir('folder1') {
                        git branch: 'branch1',
                            credentialsId: 'github_test',
                            url: 'https://github.com/AngelikaDe/test_repo.git'
                    }

                    dir('folder2') {
                        git branch: 'branch2',
                            credentialsId: 'github_test',
                            url: 'https://github.com/AngelikaDe/test_repo.git'
                    }
                }
            }
        }
        stage('List Files') {
            steps {
                script {
                    sh 'ls -l folder1'
                    sh 'ls -l folder2'
                }
            }
        }
    }
}
