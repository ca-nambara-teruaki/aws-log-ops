SELECT
  ci.awsAccountId,
  ci.awsRegion,
  ci.resourceType,
  ci.resourceId,
  ci.resourceName,
  ci.ARN,
  ci.tags,
  ci.configurationItemVersion,
  ci.configurationItemCaptureTime,
  ci.configurationStateId,
  ci.configurationItemStatus,
  ci.configurationStateMd5Hash,
  ci.relatedEvents,
  ci.relationships,
  ci.supplementaryConfiguration
FROM config_logs
CROSS JOIN UNNEST(configurationItems) AS t(ci)

SELECT
  dt,
  ci.awsAccountId,
  ci.awsRegion,
  ci.resourceType,
  ci.resourceId, 
  ci.resourceName, 
  ci.ARN, 
  ci.tags,
  ci.configurationItemVersion,
  ci.configurationItemCaptureTime,
  ci.configurationStateId,
  ci.configurationItemStatus,
  ci.configurationStateMd5Hash,
  ci.relatedEvents, 
  ci.relationships, 
  ci.supplementaryConfiguration
FROM  (config_logs
  CROSS JOIN UNNEST(configurationItems) t (ci)
)
