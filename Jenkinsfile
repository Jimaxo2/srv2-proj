pipeline {
  agent any
  stages {
    stage('Archivos del proyecto') {
      steps {
        sh 'test -f compose.yaml'
        sh 'test -f nginx.conf'
        sh 'test -f app.py'
        sh 'test -f requirements.txt'
      }
    }
    stage('Credenciales protegidas') {
      steps {
        sh 'grep -qx ".env" .gitignore'
        sh 'test ! -f .env'
      }
    }
    stage('Estructura de Compose') {
      steps {
        sh 'grep -Eq "^ +python:" compose.yaml'
        sh 'grep -Eq "^ +nginx:" compose.yaml'
        sh 'grep -Eq "^ +mysql:" compose.yaml'
        sh 'grep -q "healthcheck:" compose.yaml'
        sh 'grep -q "build:" compose.yaml'
      }
    }
    stage('Historial en Git') {
      steps {
        sh 'git log --oneline -5'
      }
    }
    stage('Sistema disponible') {
      steps {
        sh 'curl -fsS http://nginx/inventario'
      }
    }
  }
}
