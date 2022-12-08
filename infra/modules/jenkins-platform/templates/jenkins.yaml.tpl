jenkins:
    systemMessage: "Serverless Jenkins"
    numExecutors: 0
    remotingSecurity:
      enabled: true
    agentProtocols:
        - "JNLP4-connect"
    securityRealm:
        local:
            allowsSignup: false
            users:
                - id: ecsuser
                  password: \$${ADMIN_PWD}
    authorizationStrategy:
        roleBased:
          roles:
            global:
              - assignments:
                - "ecsuser"
                name: "admin"
                pattern: ".*"
                permissions:
                  - "Overall/Administer"
              - name: "developers"
                pattern: ".*"
                permissions:
                  - "Overall/Read"
                  - "Job/Build"
                  - "Lockable Resources/Unlock"
                  - "Agent/Build"
                  - "View/Read"
                  - "Run/Replay"
              - name: "devops"
                pattern: ".*"
                permissions:
                  - "Job/Move"
                  - "Job/Build"
                  - "Credentials/ManageDomains"
                  - "Lockable Resources/Unlock"
                  - "View/Create"
                  - "Agent/Configure"
                  - "Job/Read"
                  - "Credentials/Update"
                  - "Agent/Create"
                  - "Job/Delete"
                  - "Agent/Build"
                  - "View/Configure"
                  - "Lockable Resources/Reserve"
                  - "Agent/Provision"
                  - "SCM/Tag"
                  - "Job/Create"
                  - "Job/Discover"
                  - "Agent/Connect"
                  - "Agent/Delete"
                  - "Run/Replay"
                  - "Agent/Disconnect"
                  - "Run/Delete"
                  - "Job/Cancel"
                  - "Overall/Read"
                  - "Run/Update"
                  - "Credentials/Create"
                  - "View/Delete"
                  - "Job/Configure"
                  - "Job/Workspace"
                  - "View/Read"
    crumbIssuer: "standard"
    slaveAgentPort: 50000
security:
  sSHD:
    port: -1