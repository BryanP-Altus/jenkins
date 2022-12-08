#!/bin/bash
# shellcheck disable=SC2155
set -o pipefail -e

terraform_init_with_backend(){
   state_bucket=$1
   
   terraform init -backend=true -backend-config="region=${aws_region}" -backend-config="bucket=${aws_actid}-${state_bucket}" -backend-config "key=${env}-jenkins-${app}.tfstate"

   if [[ "$(terraform workspace list | grep -c "${env}" )" == 0 ]]; then
      terraform workspace new "${env}"
   else
      terraform workspace select "${env}"
      echo "switched to workspace ${env}"
   fi
}

main(){
    echo $@
    action=$1
    assume_role=$4 
    env_vars="infra/env-vars/${2}.json"
    echo ${action}
    echo "Building environment : ${2}"

    export env=${2}
    export app=${3}
    echo ${env}
    export aws_actid=$(cat "${env_vars}" | jq -r '.aws_account')
    echo ${aws_actid}
    export aws_region=$(cat "${env_vars}" | jq -r '.aws_region')
    export aws_role=$(cat "${env_vars}" | jq -r '.aws_role')
    state_bucket=$(cat "${env_vars}" | jq -r '.state_bucket_name')

    source infra/scripts/aws_helper.sh
    
    if [ "${assume_role}" == false ]; then
      echo "No switch role enabled"
    else
      aws-switch-to-build-role 
    fi
    
    case ${action} in

    "component-plan")
          cd infra/providers/${app} || exit;
          terraform get
          terraform_init_with_backend "${state_bucket}"
          terraform plan --var-file="../../env-vars/${env}.json" -out="${env}-${component}.plan" ;
          terraform show -json ${env}-${component}.plan > ${env}-${component}.json
          cd ../../../;;

    "component-build")
          cd infra/providers/${app} || exit;
          terraform get
          terraform_init_with_backend "${state_bucket}"
          terraform apply -auto-approve "${env}-${component}.plan";
          cd ../../../../;;

    "component-destroy")
          cd infra/providers/${app} || exit;
          terraform get
          terraform_init_with_backend "${state_bucket}"
          terraform destroy -auto-approve --var-file="../../env-vars/${env}.json";
          cd ../../../../;;

      "*")
            echo "Invalid input. Please check your command.";;

    esac

    if [ "${assume_role}" == false ]; then
      echo "No need to switch back role"
    else
      aws-switch-to-build-role
    fi

}

main "$@"
