import json
import boto3

sns = boto3.client('sns')

def lambda_handler(event, context):
    
    #Extract details from JSON event
    detailType= event["detail-type"]
    region = event["region"]
    accountId = event["account"] 
    
    # Task State Events
    if (detailType == "ECS Task State Change"):
        
        action = event["detail"]["lastStatus"]
        target = event["detail"]["group"]
        filterStatus = ["STOPPING","DEACTIVATING","RUNNING"]
        
        if (action in filterStatus and target.find("controller") != -1):
           #message = str(event)
           message = "Task Alert: %s in %s for account: %s\n Task Status: %s \r\n %s" % (detailType, region,accountId,action,target)
    
    elif  (detailType == "ECS Deployment State Change"):
        
        action = event["detail"]["lastStatus"]
        target = event["detail"]["group"]
        #message = str(event)
        message = "ECS Deployment Alert: %s in %s for account: %s\n Action description: %s \r\n %s" % (detailType, region,accountId,action,target)


    #ECS Service Action
    elif (detailType == "ECS Service Action"):
        message = str(event)
        action = event["detail"]["lastStatus"]
        target = event["detail"]["group"]
        message = "ECS Service Action: %s in %s for account: %s\n Action description: %s \r\n %s" % (detailType, region,accountId,action,target)
        
        
    #If the event doesn't match any of the above, return the event    
    else:
        message = str(event)
    
    response = sns.publish(
            TopicArn = "${sns_topic}",
            Message = message
            )
    
    return {
      'statusCode': 200,
      'body': json.dumps('Success!')
}
