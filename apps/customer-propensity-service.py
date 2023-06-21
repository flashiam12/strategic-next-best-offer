import datetime
import json
import random
import boto3
import os
from orms import *
from random import randint, uniform

# STREAM_NAME = "hsbc_customer_analytics_stream"
STREAM_NAME = os.environ.get("KINESIS_STREAM_NAME")


def get_data(db:Session, rows:int):
    customer_activity = db.query(CustomerActivity).filter(CustomerActivity.ACTIVITY_ID==randint(1, rows-1)).one()
    customer = db.query(CustomerRegistration).filter(CustomerRegistration.CUSTOMER_ID==customer_activity.CUSTOMER_ID).one()
    return {
        'CUSTOMER_ID': customer.CUSTOMER_ID,
        'ACTIVITY_ID': customer_activity.ACTIVITY_ID,
        'GENDER': customer.GENDER,
        'INCOME': customer.INCOME,
        'FICO': customer.FICO,
        'ACTIVITY_TYPE': customer_activity.ACTIVITY_TYPE,
        'PROPENSITY_TO_BUY': round(uniform(0.0, 0.99), 2)
        }


def generate(stream_name, kinesis_client):
    db = Session()
    print("Starting to create dataset for {} times".format(os.environ.get("ITERATION_COUNT")))
    try:
        rows = int(db.query(func.count(CustomerActivity.CUSTOMER_ID)).scalar())
        for i, x in enumerate(range(0, int(os.environ.get("ITERATION_COUNT")))):
            print("Creating dataset for {} time".format(i))   
            data = get_data(db, rows)
            print(data)
            kinesis_client.put_record(
                StreamName=stream_name,
                Data=json.dumps(data),
                PartitionKey="partitionkey")
    except Exception as e:
        print(e)
    finally:
        db.close()
    
if __name__ == '__main__':
    print("Starting batch job to produce dataset")
    generate(STREAM_NAME, boto3.client('kinesis', region_name='us-west-2'))
    print("Gracefully exitiing...")