## Jenkins CICD Pipeline

> ## Prerequisites
> - **Host:** 172.31.42.66
> - **Jenkins**
> - **Docker**
> - **Sonarqube**
> ##

I. **Install Plugins**
    <ol>
        <li>`Eclipse Temurin installer`, `openjdk-native-plugin`</li>
        <li>`SonarQube Scanner`</li>
        <li>`OWASP Dependency-Check`</li>
        <li>`Docker`, `Docker Pipeline`, `docker-build-step`, `CloudBees Docker Build and Publish`</li>
    </ol>

II. **Add Credential**   
    <pre>
        Docker: username/password
    </pre>

III. **Config Global Tool (Config Tool)**  
    <ol>
        <li> JDK: `jdk11` </li>
        <li> SonarQube Scanner: `sonar-scanner` </li>
        <li> Maven: `maven3` </li>
        <li> Dependency-Check: `DP` </li>
        <li> Docker: `docker` </li>
    </ol>

IV. **Run SonarQube on Docker**    
     <ol>
        <li> `docker run -d -p 9000:9000 sonarqube:lts-community` </li>
        <li> `Config Sonarqube Service on Browser: admin/admin` </li>
        <li> `Administration -> Security -> User -> Update Token -> Generate` </li>
    </ol>


V. **Create Pipeline**
    <br>
    
<details>
<summary>CI_Pipeline</summary>

```groovy
pipeline {
  agent any

  tools {
    jdk 'jdk11'
    maven 'maven3'
  }

  environment {
    SCANNER_HOME = tool 'sonar-scanner'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', changelog: false, poll: false, url: 'https://github.com/lytanghai/SpringBootFormRegister.git'
      }
    }

    stage('Compile') {
      steps {
        sh "mvn clean compile"
      }
    }

    stage('Sonarqube') {
      steps {
        sh ''
        ' $SCANNER_HOME/bin/sonar-scanner -Dsonar.url=http://172.31.42.66:9000/ -Dsonar.login=generatedToken -Dsonar.projectName=shopping-cart \
				-Dsonar,java.binaries=. \
				-Dsonar.projectKey=shopping-cart'
        ''
      }
    }

    stage('OWASP') {
      steps {
        dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP'
        dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
      }
    }

    stage('Build App') {
      steps {
        sh 'mvn clean install -DskipTests=true'
      }
    }

    stage('Push Image') {
      steps {
        script {
          withDockerRegistry(credentialsId: 'credientialsId', toolName: 'docker') {
            sh "docker build -t shopping-cart:latest .f docker/Dockerfile ."
            sh "docker tag shopping-cart:latest tanghailyy/shopping-cart:latest"
            sh "docker push tanghailyy/shopping-cart:latest"
          }
        }
      }
    }

    stage('Deploy Image') {
      steps {
        build job: 'CD_Pipeline', wait: true
      }
    }
  }
}
```
</details>

<details>
<summary>CD_Pipeline</summary>

```groovy
pipeline {
    agent any
    stages {
        stage('Run Application') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'credentialsId', toolName: 'docker') {
                        sh "docker run -d --name cart-service -p 8070:8070 tanghailyy/shopping-cart:latest"
                    }
                }
            }
        }
    }
}
</details>

```