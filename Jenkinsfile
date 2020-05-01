pipeline {
  agent {
    docker {
      image 'python:3.6-slim'
      args '--user 0:0'
    }

  }
  stages {
    stage('build') {
      steps {
        sh 'pip install --no-cache-dir -r requirements.txt'
      }
    }

    stage('test') {
      steps {
        sh 'pytest --capture=no --no-cov'
      }
    }

  }
}
