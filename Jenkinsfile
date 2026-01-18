pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Terraform Action')
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        TF_IN_AUTOMATION = 'true'
    }

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Maheshbharambe45/Jenkins-Terraform-EKS.git'
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
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region $AWS_DEFAULT_REGION
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when { expression { params.action == 'apply' } }
            steps {
                script {
                    def rc = sh(script: "terraform plan -detailed-exitcode -out=tfplan", returnStatus: true)
                    if (rc == 0) {
                        echo "No infra changes"
                        env.TF_CHANGES = "false"
                    } else if (rc == 2) {
                        echo "Infra changes detected"
                        env.TF_CHANGES = "true"
                    } else {
                        error "Terraform plan failed"
                    }
                }
            }
        }

        stage('Approval Before Apply') {
            when {
                allOf {
                    expression { params.action == 'apply' }
                    expression { env.TF_CHANGES == "true" }
                }
            }
            steps {
                input message: "Approve Terraform Apply ?"
            }
        }

        stage('Terraform Apply') {
            when {
                allOf {
                    expression { params.action == 'apply' }
                    expression { env.TF_CHANGES == "true" }
                }
            }
            steps {
                sh 'terraform apply --auto-approve tfplan'
            }
        }

        stage('Approval Before Destroy') {
            when { expression { params.action == 'destroy' } }
            steps {
                input message: "Are you sure you want to destroy resources ?"
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.action == 'destroy' } }
            steps {
                sh 'terraform destroy --auto-approve'
            }
        }

        stage('Configure EKS & check kubectl working') {
            when {
                allOf {
                    expression { params.action == 'apply' }
                    expression { env.TF_CHANGES == "true" }
                }
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
                    sleep 30
                    kubectl get nodes
                '''
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed — infrastructure not changed"
        }
        success {
            echo "Pipeline completed successfully"
        }
    }
}
