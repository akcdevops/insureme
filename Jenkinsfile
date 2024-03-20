pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        stage('git checkout') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'master', url: 'https://github.com/akcdevops/Insure_me.git'
            }
            post {
                always{
                  slackSend channel: 'jenkins', 
                  color: 'green', 
                  message:"started  JOB_NAME:${env.JOB_NAME} BUILD_NUMBER:${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)",
                  notifyCommitters: true,  
                  teamDomain: 'dwithitechnologies', 
                  tokenCredentialId: 'slack'
                }
            }
        }
        stage('Build')
        {
            steps
            {
               sh 'mvn clean package install site surefire-report:report'
            }  
        }
        stage('Artifact Upload to S3'){
            steps{
               script{
                 withAWS(credentials: 'awscred',region: 'ap-south-1') 
                 {
                    s3Upload(bucket: 'akcdevops-project1', path: '/target/insure-me-1.0.jar',file: 'target/insure-me-1.0.jar')
                 }
               } 
            }
             

        }
        stage('provisioning test server'){
            steps{
                sh 'terraform init'
                sh 'terraform plan -var-file=test.tfvars'
                input {
                    // Optional: Prompt for confirmation before applying changes
                    message 'Ready to apply Terraform changes? (y/N)'
                    ok 'Yes'
                    cancel 'No'
                }
                script {
                    if (input.trim() == 'y' || input.trim() == 'Y') {
                        sh 'terraform apply -var-file=test.tfvars'  // Apply Terraform configuration changes
                    } else {
                        echo 'Terraform apply cancelled.'
                    }
                }

                
            }
        }
        stage('provisioning prod server'){
            steps{
                sh 'terraform init'
                sh 'terraform plan -var-file=prod.tfvars'
                input {
                    // Optional: Prompt for confirmation before applying changes
                    message 'Ready to apply Terraform changes? (y/N)'
                    ok 'Yes'
                    cancel 'No'
                }
                script {
                    if (input.trim() == 'y' || input.trim() == 'Y') {
                        sh 'terraform apply -var-file=prod.tfvars'  // Apply Terraform configuration changes
                    } else {
                        echo 'Terraform apply cancelled.'
                    }
                }
            }
        }
        stage('ssh-copy-id'){
            steps{
                withCredentials([sshUserPrivateKey(credentialsId: 'jenkins.pem', keyFileVariable: '')]) {
                    script {
                        sh sshcopyid.sh  
                    }
                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                script {
                    withAWS(credentials: 'awscred',region: 'ap-south-1') 
                    {  
                    sh 'ansible-playbook -i ec2.py tomcat.yml'
                    }
                }
            }
        }
        
       
    }
    post{
        success{
            publishHTML([
                allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'target/site', reportFiles: 'surefire-report.html', reportName: 'Report', reportTitles: '', useWrapperFileDirectly: true])
        }
    }
}