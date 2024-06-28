"""
    Author: @roxsross
    AWS ECS DEMO
    Description: This is a simple Flask Voting App that allows user to vote on options
"""

from flask import Flask, request, jsonify
import boto3
import os
import logging
import json
from flask.templating import render_template
import decimal
from botocore.exceptions import EndpointConnectionError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

APP_AWS_REGION = os.environ['APP_AWS_REGION'] if 'APP_AWS_REGION' in os.environ else 'us-east-1'
APP_DDB_TABLE_NAME = os.environ['APP_DDB_TABLE_NAME'] if 'APP_DDB_TABLE_NAME' in os.environ else 'app-demo-data'
APP_PORT = os.environ['APP_PORT'] if 'APP_PORT' in os.environ else 9090
APP_MODE = os.environ['APP_MODE'] if 'APP_MODE' in os.environ else 'LOCAL'
APP_DEBUG = True if APP_MODE == 'LOCAL' else False

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return int(obj)
        return super(DecimalEncoder, self).default(obj)

app = Flask(__name__, template_folder='html', static_folder='html/static')
app.json_encoder = DecimalEncoder

def get_dynamodb_resource():
    try:
        if APP_MODE == 'PROD':
            return boto3.resource('dynamodb', region_name=APP_AWS_REGION)
        else:
            return boto3.resource('dynamodb', region_name=APP_AWS_REGION, endpoint_url='http://dynamodb-local:8000')
    except EndpointConnectionError as e:
        logging.error(f'Failed to connect to DynamoDB: {str(e)}')
        return None

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/api/options', methods=['GET', 'OPTIONS'])
def get_options():
    dynamodb = get_dynamodb_resource()
    if dynamodb is None:
        return jsonify({'error': 'Failed to connect to DynamoDB. Please try again later.'}), 500

    data = []
    table = dynamodb.Table(APP_DDB_TABLE_NAME)
    scan_kwargs = {}
    done = False
    start_key = None
    while not done:
        if start_key:
            scan_kwargs['ExclusiveStartKey'] = start_key
        try:
            response = table.scan(**scan_kwargs)
            data.extend(response.get('Items'))
            start_key = response.get('LastEvaluatedKey', None)
            done = start_key is None
        except Exception as e:
            logging.error(f'Error scanning DynamoDB table: {str(e)}')
            return jsonify({'error': 'Failed to fetch data from DynamoDB.'}), 500

    return jsonify(data)

@app.route('/api/options', methods=['POST'])
def vote_option():
    """
    Endpoint for voting on an option.

    Parameters:
    - content (dict): The request payload containing the option ID.

    Returns:
    - response (dict): The response message indicating the success or failure of the request.
    """
    content = request.json
    logging.info('Returning options')
    logging.info('Request received: {}'.format(content))

    response = {}
    if 'ID' not in content:
        response['message'] = 'Malformed request'
        return jsonify(response), 400

    dynamodb = get_dynamodb_resource()
    if dynamodb is None:
        return jsonify({'error': 'Failed to connect to DynamoDB. Please try again later.'}), 500

    table = dynamodb.Table(APP_DDB_TABLE_NAME)
    try:
        table.update_item(
            Key={
                'ID': content['ID'],
            },
            UpdateExpression='ADD votes :inc',
            ExpressionAttributeValues={
                ':inc': 1
            }
        )
        response['message'] = 'Request processed'
        return jsonify(response), 200
    except Exception as e:
        logging.error(f'Error updating item in DynamoDB: {str(e)}')
        return jsonify({'error': 'Failed to process request. Please try again later.'}), 500

if __name__ == '__main__':
    print('Hello from DevTalk')
    app.run(port=APP_PORT, host='0.0.0.0', debug=APP_DEBUG)
