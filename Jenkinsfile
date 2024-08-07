pipeline {
    agent any
    
    tools {
        maven 'local_maven'
    }
        environment {     
            DOCKERHUB_CREDENTIALS= credentials('docker-hub')     
        } 

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true -e -X'
            }
            post {
                success {
                    echo 'Archiving the artifacts'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
    stage('Build Docker Image') {         
        steps{                
	sh 'docker build -t praj0404/javadocker:$BUILD_NUMBER .'           
        echo 'Build Image Completed'                
        }           
    }
    stage('Login to Docker Hub') {         
        steps{                            
	sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                 
	echo 'Login Completed'                
        }           
    }
    stage('Scan Docker Image with Trivy') {         
        steps{                            
	sh 'trivy image praj0404/javadocker:$BUILD_NUMBER'              
        }           
    }    
    stage('Push Image to Docker Hub') {         
        steps{                            
	sh 'docker push praj0404/javadocker:$BUILD_NUMBER'                 
    echo 'Push Image Completed'       
        }           
    }
    stage('Run Container on Dev Server') {         
    steps{
	script {
        def dockerdel = "docker rm -f myweb"
        def dockerRun = "docker run -p 8080:8080 -d --name myweb praj0404/javadocker:$BUILD_NUMBER"

	sshagent(['docker']) {
        sh "ssh -o StrictHostKeyChecking=no ubuntu@65.0.45.96 ${dockerdel}"
        sh "ssh -o StrictHostKeyChecking=no ubuntu@65.0.45.96 ${dockerRun}"
}
	}
    }       
    }   

  } //stages 
    post{
    always {  
        sh 'docker logout'           
    }      

    }
}