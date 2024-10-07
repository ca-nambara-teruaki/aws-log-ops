CREATE EXTERNAL TABLE vpc_flow_logs (
  account_id string,
  action string,
  az_id string,
  bytes bigint,
  dstaddr string,
  dstport int,
  endtime bigint,
  flow_direction string,
  instance_id string,
  interface_id string,
  log_status string,
  packets int,
  pkt_dst_aws_service string,
  pkt_dstaddr string,
  pkt_src_aws_service string,
  pkt_srcaddr string,
  protocol int,
  region string,
  srcaddr string,
  srcport int,
  starttime bigint,
  sublocation_id string,
  sublocation_type string,
  subnet_id string,
  tcp_flags int,
  traffic_path int,
  ip_type string,
  version int,
  vpc_id string
)
PARTITIONED BY (
   `dt` string
)
STORED AS PARQUET
LOCATION 's3://${bucket_name}/VpcFlowLogs/${vpc_id}/AWSLogs/${aws_account_id}/vpcflowlogs/ap-northeast-1/'
TBLPROPERTIES (
  'projection.enabled'='true', 
  'projection.dt.format'='yyyy/MM/dd', 
  'projection.dt.interval'='1', 
  'projection.dt.interval.unit'='DAYS', 
  'projection.dt.range'='2020/01/01,NOW', 
  'projection.dt.type'='date', 
  'storage.location.template' = 's3://${bucket_name}/VpcFlowLogs/${vpc_id}/AWSLogs/${aws_account_id}/vpcflowlogs/ap-northeast-1/${dt}'
);
