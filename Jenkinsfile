pipeline {
    agent any
    tools {
        terraform 'terraform-11'
    }

    stages {
        stage('Setup parameters') {
            steps {
                script {
                    properties([
                        parameters([
                            string(
                                defaultValue: 'deploy-mysql',
                                description: 'This parameter decides the name of terraform workspace',
                                name: 'NAME_TF_WORKSPACE'
                            ),
                            string(
                                defaultValue: '7676dcd5-03ce-446e-8045-7ba0dbf6e558',
                                description: 'User ID in Keycloak',
                                name: 'USER_ID_KEYCLOAK'
                            ),
                            string(
                                defaultValue: 'http://127.0.0.1:8081/auth/admin/realms/master/users/7676dcd5-03ce-446e-8045-7ba0dbf6e558',
                                description: 'URL of the user in Keycloak',
                                name: 'URL_KEYCLOAK'
                            ),
                            string(
                                defaultValue: '8e2f9510-f34c-4dec-a01a-10d3d046412a',
                                description: 'Client Secret of the user in Keycloak',
                                name: 'KEYCLOAK_CLIENT_SECRET'
                            ),
                            string(
                                defaultValue: '790131216438-2g4tmjsldi9a861m59uple5d1bvigfft.apps.googleusercontent.com',
                                description: 'Client ID of OAuth client in GCP',
                                name: 'APP_CLIENT_ID'
                            ),
                            string(
                                defaultValue: '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',
                                description: 'Client Secret of OAuth client in GCP',
                                name: 'APP_CLIENT_SECRET'
                            )
                        ])
                    ])
                }
            }
        }

        stage('Get GCP access token') {
            steps {
                script{
                    sh '''cd /opt/ServiceAccount/syndeno
                    ./accesstoken.sh
                    '''
                }
            }
        }
    


        stage('Git Checkout') {
            steps {
                git credentialsId: 'c94f1316-a4c0-4691-b147-32f390296144', url: 'https://github.com/VietNguyen408/deploy-mysql'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh '''export TF_VAR_access_token=$(cat /opt/ServiceAccount/syndeno/GCP_ACCESS_TOKEN.txt)
                    terraform init -reconfigure -force-copy -backend-config="access_token=$TF_VAR_access_token" || terraform init -migrate-state -force-copy -backend-config="access_token=$TF_VAR_access_token"
                    terraform workspace select ${NAME_TF_WORKSPACE} || terraform workspace new ${NAME_TF_WORKSPACE} #Will execute second command if first fails
                    terraform workspace show
                    terraform workspace list
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh '''export TF_VAR_access_token=$(cat /opt/ServiceAccount/syndeno/GCP_ACCESS_TOKEN.txt)
                    terraform apply --auto-approve
                    '''
                }
            }
        }
    }
}