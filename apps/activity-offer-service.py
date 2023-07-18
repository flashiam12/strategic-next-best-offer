import os
from google.cloud.pubsub_v1 import PublisherClient
import json
from typing import List
from random import randint, choice
from faker import Faker

def get_data(dataset:List[dict]):
        fake = Faker()
        ranges = {
             "0.10":"0.50",
             "0.50":"0.70",
             "0.70":"0.99"
        }
        data = dataset[randint(0, len(dataset)-1)]
        data["offer_id"] = fake.lexify()
        data["offer_name"] = fake.bs()
        data['prop_min'] = choice(list(ranges.keys()))
        data['prop_max'] = ranges[data["prop_min"]]

        return data

def generator():
    
    with open('{}/activity-offers.json'.format(os.path.curdir), 'r') as f:
        dataset = json.load(f)

    publisher = PublisherClient()

    topic_name = 'projects/{project_id}/topics/{topic}'.format(
        project_id=os.environ.get('GCP_PROJECT'),
        topic=os.environ.get('GCP_PUB_SUB_TOPIC'),  # Set this to something appropriate.
    )
    
    try:
         for i, x in enumerate(range(0, int(os.environ.get("ITERATION_COUNT")))): 
            data = json.dumps(get_data(dataset))
            future = publisher.publish(topic_name, data.encode(), spam='eggs')
            print(future.result())
    except Exception as e:
        print(e)
    finally:
         publisher.stop()

if __name__=="__main__":
    print("Starting batch job to produce dataset")
    generator()
    print("Gracefully exitiing...")
