pipeline{
    agent any

    environment{
        AWS_ACCESS_KEY_ID = credentials('AWS_Access_Key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_Secret_Key')
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages{
        stage('check files'){
            steps{sh 'ls -l '}
        }

        stage('configure aws cli') {
            steps {
                sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region $AWS_DEFAULT_REGION
                    
                    echo "AWS CLI configured"
                '''
            }
        }

        stage('Terraform Initilzation'){
            steps{sh 'Terraform init'}
        }

        stage('Terraform validation'){
            steps{sh 'Terraform validate'}
        }

        stage('Terraform plan (Blueprint)'){
            steps{sh 'Terraform plan'}
        }

        stage('Terraform applying/destroying'){
            steps{sh 'Terraform $action --auto-approve'}
        }
    }
}