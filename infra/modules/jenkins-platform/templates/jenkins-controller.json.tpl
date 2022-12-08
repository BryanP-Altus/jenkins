[
    {
      "name": "${name}",
      "image": "${container_image}",
      "environment": [
        {"name" : "JAVA_OPTS", "value": "-Djenkins.install.runSetupWizard=false" },
        {"name" : "PROJECT", "value": "${project}" },
        {"name" : "SHORT_PROJECT", "value": "${project_short_name}" },
        {"name" : "SG_GROUP", "value": "${security_group}" },
        {"name" : "DOCKER_CREDENTIALS", "value": "${docker_secret_arn}" }
      ],
      "repositoryCredentials": {
        "CredentialsParameter": "${credentialsParam}"
      },
      "essential": true,
      "mountPoints": [
        {
          "containerPath": "${jenkins_home}",
          "sourceVolume": "${source_volume}"
        }
      ],
      "portMappings": [
        {
          "containerPort": ${jenkins_controller_port}
        },
        {
          "containerPort": ${jnlp_port}
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${log_group}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "controller"
        }
      },
      "secrets": [
        {
          "name": "ADMIN_PWD",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/jenkins-pwd"
        },
        {
          "name": "AZURE_ID",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/jenkins/sso/${project_short_name}/client_id"
        },
        {
          "name": "AZURE_SECRET",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/jenkins/sso/${project_short_name}/secret_encrypt"
        },
        {
          "name": "AZURE_TENANT",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/jenkins/sso/tenant_id"
        },
        {
          "name": "JFROG_PWD",
          "valueFrom": "${credentialsParam}:password::"
        },
        {
          "name": "AWS_KEY",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/jenkins/${project_short_name}/aws_key"
        },
        {
          "name": "AWS_SECRET",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/jenkins/${project_short_name}/aws_secret_encrypt"
        },
        {
          "name": "SNS_TOPIC",
          "valueFrom": "arn:aws:ssm:${region}:${account_id}:parameter/ci/jenkins/${project}/sns"
        }
      ]
    },
    {
      "name": "jenkins-${project_short_name}-dd_agent",
      "image" : "datadog/agent:latest",
      "essential": true,
      "dependsOn": [
      ],
      "mountPoints": [],
      "portMappings": [
        {
          "protocol": "udp",
          "containerPort": 8125,
          "hostPort": 8125
        },
        {
          "protocol": "tcp",
          "containerPort": 8126,
          "hostPort": 8126
        },
        {
          "protocol": "tcp",
          "containerPort": 10518,
          "hostPort": 10518
        }
      ],
      "environment": [
        {
          "name": "ECS_FARGATE",
          "value": "true"
        },
        {
          "name": "DD_API_KEY",
          "value": "${datadogApiKey}"
        },
        {
          "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
          "value": "true"
        },
        {
          "name": "DD_APM_ENABLED",
          "value": "true"
        },
        {
          "name": "DD_SITE",
          "value": "datadoghq.eu"
        },
        {
          "name": "DD_APM_NON_LOCAL_TRAFFIC",
          "value": "true"
        },
        {
          "name": "DD_PROCESS_AGENT_ENABLED",
          "value": "true"
        }
      ]
    }
]
  