import boto3
import sys


def get_tagged_instances(ec2_client, tagkey: str, tagvalue: str) -> list:
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:'+tagkey,
                'Values': [tagvalue]
            }
        ]
    )
    instancelist = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instancelist.append(instance["InstanceId"])
    
    return instancelist


def stop_instances(ec2_client, instance_ids: list) -> None:
    try:
        ec2_client.stop_instances(InstanceIds=instance_ids)
    except:
        e = sys.exc_info()[0]
        print(e)
        return
    print('--- instance: ',instance_ids,' has been shutdown ---')
    return


def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    instance_ids = get_tagged_instances(ec2_client, 'Auto-Shutdown', 'True')
    
    if len(instance_ids) != 0:
        stop_instances(ec2_client, instance_ids)
    else:
        print('No instances found with Auto-Shutdown tag set to True')
    return