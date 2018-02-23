pipeline {
    agent {
        label "temp-ci"
    }
    options {
        skipDefaultCheckout true
        buildDiscarder(logRotator(numToKeepStr:'1'))
        disableConcurrentBuilds()
    }
    stages {
        stage("VALIDATE") {
            steps {
                script {
                    git poll: false, url: 'https://github.com/singhsurjeet/terraform-aws-vpc.git'
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform validate -check-variables=true"
                    }
                }

            }
        }

        stage("GENERATE PLAN") {
            steps {
                script {
                    dir('terraform') {
                        sh "./tfplan.sh"
                    }
                }
            }
        }
        stage("APPROVE PLAN") {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input 'Do you want to apply the plan?'
                }
            }
        }

        stage("APPLY") {
            steps {
                script {
                    dir('terraform') {
                        sh "./tfapply.sh"
                        sh "sleep 30"
                    }
                }
            }
        }
        stage("TEST") {
            steps {
                script {
                    dir('specs') {
                        sh "gem install bundler"
                        sh "bundle install"
                        sh "bundle exec rake spec"
                        sh "bundle exec rake generate_report"
                    }
                }
            }
            post {
                always {
                    allure includeProperties: false, jdk: '', report: 'specs/reports/Allure-HTML-Report', results: [[path: 'specs/reports/Allure-results']]
                }
            }
        }

        stage("COMPLIANCE TEST") {
            steps {
                script {
                    dir('specs') {
                        sh "aws s3 cp --source-region us-east-1 s3://terraform-demo-remote-state/mykey.pem ~/.ssh/"
                        sh "chmod 400 ~/.ssh/mykey.pem"
                        sh "gem install bundler"
                        sh "bundle install"
                        sh "rake inspec_tests inspec/controls ~/.ssh/mykey.pem"
                    }
                }
            }
        }


        stage("GENERATE DESTROY PLAN") {
            steps {
                script {
                    dir('terraform') {
                        sh "./tfplan.sh -destroy"
                    }
                }
            }
        }

        stage("APPROVE DESTROY PLAN") {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input 'Do you want to destroy the env?'
                }
            }
        }
        stage("DESTROYING NOW") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform destroy -force"
                    }
                }
            }
        }
    }
}
