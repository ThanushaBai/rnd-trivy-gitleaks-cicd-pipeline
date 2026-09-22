pipeline {
    agent any

    environment {
        IMAGE_NAME = "sample-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Gitleaks Secret Scan') {
            steps {
                echo 'Scanning for secrets with Gitleaks...'
                sh '''
                    docker run --rm \
                        -v "$WORKSPACE:/src" \
                        zricethezav/gitleaks:latest \
                        detect \
                        --source="/src" \
                        --verbose \
                        --redact \
                        --exit-code=1
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Verify Image') {
            steps {
                echo 'Verifying image runs correctly...'
                sh "docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} node -e \"console.log('Image works')\""
            }
        }
    }

    post {
        always {
            echo "Pipeline completed with status: ${currentBuild.currentResult}"
        }
        success {
            echo 'Build succeeded.'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
