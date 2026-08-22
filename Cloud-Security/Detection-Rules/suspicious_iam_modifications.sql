SELECT eventTime, userIdentity.arn, eventName, sourceIPAddress, errorMessage 
FROM cloudtrail_logs 
WHERE eventName = 'PutBucketAcl' OR eventName = 'CreateAccessKey' 
  AND errorCode IS NOT NULL;
