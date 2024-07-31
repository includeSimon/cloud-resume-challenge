import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloudresume-test')

def lambda_handler(event, context):
    response = table.get_item(Key={'id': '1'})
    if 'Item' in response:
        views = response['Item']['views']
    else:
        views = 0
    views += 1
    table.put_item(Item={'id': '1', 'views': views})
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({'views': int(views)})
    }
