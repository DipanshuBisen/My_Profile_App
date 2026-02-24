pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "dipanshubisen/static-website"
        DOCKER_TAG = "latest"
        EC2_HOST = "13.203.193.181"
        EC2_USER = "ubuntu"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/DipanshuBisen/My_Profile_App.git'
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                if [ -d "tests" ]; then
                    echo "Running Tests..."
                    chmod +x tests/*.sh || true
                    for file in tests/*.sh; do
                        bash $file
                    done
                else
                    echo "No tests folder found. Skipping tests."
                fi
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-creds') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                        docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker stop website || true
                        docker rm website || true
                        docker run -d -p 80:80 --name website ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '
                    """
                }
            }
        }
    }

    post {

        success {
            emailext(
                subject: "✅ SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                Good News 🎉

                Job Name: ${env.JOB_NAME}
                Build Number: ${env.BUILD_NUMBER}
                Status: SUCCESS
                Build URL: ${env.BUILD_URL}

                The application has been successfully deployed to EC2.
                """,
                to: "dipanshubisen15@gmail.com"
            )
        }

        failure {
            emailext(
                subject: "❌ FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                Attention ⚠

                Job Name: ${env.JOB_NAME}
                Build Number: ${env.BUILD_NUMBER}
                Status: FAILURE
                Build URL: ${env.BUILD_URL}

                Please check the console logs immediately.
                """,
                to: "dipanshubisen15@gmail.com"
            )
        }

        always {
            echo "Pipeline finished with status: ${currentBuild.currentResult}"
        }
    }
}