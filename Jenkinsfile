pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage('Check Files') {
            steps { 
                sh 'ls -l' 
            }
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

        stage('Terraform Initialization') {
            steps { 
                sh 'terraform init' 
            }
        }

        stage('Import existing KMS alias') {
            steps {
                sh '''
                    echo "Importing existing KMS alias..."
                    terraform import module.eks.module.kms.aws_kms_alias.this["cluster"] alias/eks/hotstar-eks || echo "Alias already imported"
                '''
            }
        }
        
        stage('Terraform Validation') {
            steps { 
                sh 'terraform validate' 
            }
        }

        stage('Terraform Plan (Blueprint)') {
            steps { 
                sh 'terraform plan' 
            }
        }



        stage('Terraform Apply/Destroy') {
            steps { 
                sh "terraform ${params.action} --auto-approve" 
            }
        }

        stage('Configure EKS & check kubectl working') {
            when {
                expression { params.action != 'destroy' }
            }
            steps {
                sh '''
                    echo "Creating EKS access entry..."
                    aws eks create-access-entry --cluster-name hotstar-eks --principal-arn arn:aws:iam::892706795826:user/Terrafrom-User --type STANDARD --region $AWS_DEFAULT_REGION || echo "Access entry may already exist"

                    echo "Associating access policy..."
                    aws eks associate-access-policy --cluster-name hotstar-eks --principal-arn arn:aws:iam::892706795826:user/Terrafrom-User --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy --access-scope '{"type":"cluster"}' --region $AWS_DEFAULT_REGION || echo "Policy may already be associated"

                    echo "Updating kubeconfig..."
                    aws eks update-kubeconfig --name hotstar-eks --region $AWS_DEFAULT_REGION --alias hotstar-eks

                    echo "Checking EKS nodes..."
                    kubectl get nodes
                '''
            }
        }
    }
}
