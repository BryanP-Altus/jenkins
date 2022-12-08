locals {
  environment    = "ci"
  component      = "pipeline"
  scope          = "jenkins"
  business_owner = "devops"
  submodule      = "Codebuild Project"
  custom_policy  = ""

  pipeline_stages_devops = [
    {
      name : "Common-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-devops-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputDevopsJenkinsCommonPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "devops", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-devops",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputDevopsJenkinsCommonPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "devops", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputDevopsJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Manual-Approval",
      action : [
        {
          name : "Devops-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Common-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-devops-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputDevopsJenkinsCommonPlan"],
          output_artifacts : ["OutputDevopsJenkinsCommonBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "devops", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputDevopsJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
   {
      name : "Platform-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-devops-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputDevopsJenkinsPlatformPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "devops", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-devops",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputDevopsJenkinsPlatformPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "devops", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputDevopsJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Manual-Approval",
      action : [
        {
          name : "Devops-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Platform-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-devops-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputDevopsJenkinsPlatformPlan"],
          output_artifacts : ["OutputDevopsJenkinsPlatformBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "devops", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputDevopsJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
  ]
  pipeline_stages_platform = [
    {
      name : "Common-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-platform-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputPlatformJenkinsCommonPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputPlatformJenkinsCommonPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputPlatformJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Manual-Approval",
      action : [
        {
          name : "Platform-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Common-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-platform-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputPlatformJenkinsCommonPlan"],
          output_artifacts : ["OutputPlatformJenkinsCommonBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputPlatformJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
   {
      name : "Platform-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-platform-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputPlatformJenkinsPlatformPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputPlatformJenkinsPlatformPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputPlatformJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Manual-Approval",
      action : [
        {
          name : "Platform-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Platform-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-platform-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputPlatformJenkinsPlatformPlan"],
          output_artifacts : ["OutputPlatformJenkinsPlatformBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputPlatformJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
  ]
  pipeline_stages_so = [
    {
      name : "Common-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-so-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputSoJenkinsCommonPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "strategy-offer", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-so",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSoJenkinsCommonPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "strategy-offer", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSoJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Manual-Approval",
      action : [
        {
          name : "SO-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Common-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-so-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSoJenkinsCommonPlan"],
          output_artifacts : ["OutputSoJenkinsCommonBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "strategy-offer", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSoJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
   {
      name : "Platform-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-so-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputSoJenkinsPlatformPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "strategy-offer", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-so",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSoJenkinsPlatformPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "strategy-offer", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSoJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Manual-Approval",
      action : [
        {
          name : "SO-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Platform-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-so-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSoJenkinsPlatformPlan"],
          output_artifacts : ["OutputSoJenkinsPlatformBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "strategy-offer", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSoJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
  ]
  pipeline_stages_genesis = [
    {
      name : "Common-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-genesis-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputGenesisJenkinsCommonPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "genesis", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-genesis",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputGenesisJenkinsCommonPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "genesis", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputGenesisJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Manual-Approval",
      action : [
        {
          name : "Genesis-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Common-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-genesis-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputGenesisJenkinsCommonPlan"],
          output_artifacts : ["OutputGenesisJenkinsCommonBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "genesis", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputGenesisJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
   {
      name : "Platform-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-genesis-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputGenesisJenkinsPlatformPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "genesis", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-genesis",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputGenesisJenkinsPlatformPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "genesis", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputGenesisJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Manual-Approval",
      action : [
        {
          name : "Genesis-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Platform-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-genesis-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputGenesisJenkinsPlatformPlan"],
          output_artifacts : ["OutputGenesisJenkinsPlatformBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "genesis", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputGenesisJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
  ]
  pipeline_stages_sandbox = [
    {
      name : "Common-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-sandbox-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputSandboxJenkinsCommonPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "sandbox", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-sandbox",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSandboxJenkinsCommonPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "sandbox", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSandboxJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Common-Manual-Approval",
      action : [
        {
          name : "Sandbox-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Common-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-sandbox-common",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSandboxJenkinsCommonPlan"],
          output_artifacts : ["OutputSandboxJenkinsCommonBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "sandbox", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "common", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSandboxJenkinsCommonPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
   {
      name : "Platform-Static-Code-Analysis",
      action : [
        {
          name : "checkov-jenkins-sandbox-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact"],
          output_artifacts : ["OutputSandboxJenkinsPlatformPlan"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-checkov",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "sandbox", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Compliance-Policy",
      action : [
        {
          name : "infracost-jenkins-sandbox",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSandboxJenkinsPlatformPlan"],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-infracost",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-plan", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "sandbox", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSandboxJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
    {
      name : "Platform-Manual-Approval",
      action : [
        {
          name : "Sandbox-Lead-Approval",
          category : "Approval",
          owner : "AWS",
          provider : "Manual",
          input_artifacts : [],
          output_artifacts : [],
          version : "1",
          run_order : "1",
          configuration : {
            "CustomData" : "Please review the security checks and estimation costs to approve the provisioning"
          }
        }
      ]
    },
    {
      name : "Platform-Infrastructure-Deployment",
      action : [
        {
          name : "deploy-jenkins-sandbox-platform",
          category : "Build",
          owner : "AWS",
          provider : "CodeBuild",
          input_artifacts : ["SourceArtifact", "OutputSandboxJenkinsPlatformPlan"],
          output_artifacts : ["OutputSandboxJenkinsPlatformBuild"],
          version : "1",
          run_order : "1",
          configuration : {
            "ProjectName" : "app-build",
            "PrimarySource" : "SourceArtifact"
            "EnvironmentVariables" : jsonencode([
              { "name" : "action", "value" : "component-build", "type" : "PLAINTEXT" },
              { "name" : "env", "value" : "sandbox", "type" : "PLAINTEXT" },
              { "name" : "component", "value" : "platform", "type" : "PLAINTEXT" },
              { "name" : "artifact", "value" : "OutputSandboxJenkinsPlatformPlan", "type" : "PLAINTEXT" }
            ])
          }
        }
      ]
    },
  ]  
}
