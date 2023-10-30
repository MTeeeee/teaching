import json
import boto3
import uuid
import os

def lambda_handler(event, context):
    # TODO implement
    message = json.loads(json.loads(event["Records"][0]["body"])["Message"])["Records"][0]["s3"]["object"]["key"]
    table_name = os.environ['DYNAMODB_TABLE_NAME']
    
    file_name = str(uuid.uuid4()) + '.txt'

    db = boto3.client('dynamodb')
    response = db.put_item(
        TableName=table_name,
        Item={
            'Id': {
                'S': file_name
            }
        })
    
    return {
        'statusCode': 200,
        'body': json.dumps(file_name)
    }
