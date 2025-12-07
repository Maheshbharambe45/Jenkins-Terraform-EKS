pipeline{
    agent any

    environment{
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages{
        stage('check files'){
            steps{sh 'ls -l '}
        }


        stage('Configure AWS CLI') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'AWS_Access_Key', 
                    usernameVariable: 'AWS_ACCESS_KEY_ID', 
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        echo "Configuring AWS CLI..."
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region $AWS_DEFAULT_REGION
                        aws configure list
                    '''
                }
            }
        }

        stage('Terraform Initilzation'){
            steps{sh 'terraform init'}
        }

        stage('Terraform validation'){
            steps{sh 'terraform validate'}
        }

        stage('Terraform plan (Blueprint)'){
            steps{sh 'terraform plan'}
        }

        stage('Terraform applying/destroying'){
            steps{sh 'terraform $action --auto-approve'}
        }
    }
}