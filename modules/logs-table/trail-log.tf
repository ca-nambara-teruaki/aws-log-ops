resource "aws_glue_catalog_table" "trail_logs" {
  name          = "trail_logs"
  database_name = aws_glue_catalog_database.logs.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "projection.dt.range"         = "2020/01/01,NOW"
    "projection.dt.interval.unit" = "DAYS"
    "EXTERNAL"                    = "TRUE"
    "projection.dt.type"          = "date"
    "transient_lastDdlTime"       = "1728027663"
    "projection.enabled"          = "true"
    "projection.dt.interval"      = "1"
    "projection.dt.format"        = "yyyy/MM/dd"
    "storage.location.template"   = "s3://${var.system_logs_bucket}/Trail/AWSLogs/${var.aws_account_id}/CloudTrail/ap-northeast-1/$${dt}"
  }

  storage_descriptor {
    location      = "s3://${var.system_logs_bucket}/Trail/AWSLogs/${var.aws_account_id}/CloudTrail/ap-northeast-1"
    input_format  = "com.amazon.emr.cloudtrail.CloudTrailInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    columns {
      name = "eventversion"
      type = "string"
    }

    columns {
      name = "useridentity"
      type = "struct<type:string,principalId:string,arn:string,accountId:string,invokedBy:string,accessKeyId:string,userName:string,onBehalfOf:struct<userId:string,identityStoreArn:string>,sessionContext:struct<attributes:struct<mfaAuthenticated:string,creationDate:string>,sessionIssuer:struct<type:string,principalId:string,arn:string,accountId:string,userName:string>,ec2RoleDelivery:string,webIdFederationData:struct<federatedProvider:string,attributes:map<string,string>>>>"
    }

    columns {
      name = "eventtime"
      type = "string"
    }

    columns {
      name = "eventsource"
      type = "string"
    }

    columns {
      name = "eventname"
      type = "string"
    }

    columns {
      name = "awsregion"
      type = "string"
    }

    columns {
      name = "sourceipaddress"
      type = "string"
    }

    columns {
      name = "useragent"
      type = "string"
    }

    columns {
      name = "errorcode"
      type = "string"
    }

    columns {
      name = "errormessage"
      type = "string"
    }

    columns {
      name = "requestparameters"
      type = "string"
    }

    columns {
      name = "responseelements"
      type = "string"
    }

    columns {
      name = "additionaleventdata"
      type = "string"
    }

    columns {
      name = "requestid"
      type = "string"
    }

    columns {
      name = "eventid"
      type = "string"
    }

    columns {
      name = "readonly"
      type = "string"
    }

    columns {
      name = "resources"
      type = "array<struct<arn:string,accountId:string,type:string>>"
    }

    columns {
      name = "eventtype"
      type = "string"
    }

    columns {
      name = "apiversion"
      type = "string"
    }

    columns {
      name = "recipientaccountid"
      type = "string"
    }

    columns {
      name = "serviceeventdetails"
      type = "string"
    }

    columns {
      name = "sharedeventid"
      type = "string"
    }

    columns {
      name = "vpcendpointid"
      type = "string"
    }

    columns {
      name = "eventcategory"
      type = "string"
    }

    columns {
      name = "tlsdetails"
      type = "struct<tlsVersion:string,cipherSuite:string,clientProvidedHostHeader:string>"
    }

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }
  }

  partition_keys {
    name = "dt"
    type = "string"
  }
}
