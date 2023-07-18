import json
import boto3
import os
from random import uniform

from confluent_kafka import Consumer
from confluent_kafka.serialization import SerializationContext, MessageField
from confluent_kafka.schema_registry.json_schema import JSONDeserializer
from confluent_kafka.schema_registry.schema_registry_client import SchemaRegistryClient

def read_ccloud_config(config_file):
    conf = {}
    with open(config_file) as fh:
        for line in fh:
            line = line.strip()
            if len(line) != 0 and line[0] != "#":
                parameter, value = line.strip().split('=', 1)
                conf[parameter] = value.strip()
    print(conf)
    return conf

def get_data(kinesis_client, stream_name):
    props = read_ccloud_config("client.properties")
    props["group.id"] = "customer-activity-scoring"
    props["auto.offset.reset"] = "earliest"
    props["sasl.username"] = os.environ.get("KAFKA_SASL_USERNAME")
    props["sasl.password"] = os.environ.get("KAFKA_SASL_PASSWORD")
    consumer = Consumer(props)
    consumer.subscribe([os.environ.get("KAFKA_TOPIC")])

    sr = SchemaRegistryClient({'url':os.environ.get("SR_URL"), 'basic.auth.user.info':os.environ.get("SR_AUTH")})
    value_schema = sr.get_schema(schema_id=int(os.environ.get("VALUE_SR_ID")))
    key_schema = sr.get_schema(schema_id=int(os.environ.get("KEY_SR_ID")))
    value_json_deserializer = JSONDeserializer(schema_str=value_schema.schema_str)
    key_json_deserializer = JSONDeserializer(schema_str=key_schema.schema_str)

    while True:
        try:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            value = value_json_deserializer(msg.value(), SerializationContext(msg.topic(), MessageField.VALUE))
            key = key_json_deserializer(msg.key(), SerializationContext(msg.topic(), MessageField.KEY))

            if value is not None:
                value["PROPENSITY_TO_BUY"] = round(uniform(0.0, 0.99), 2)
                kinesis_client.put_record(
                    StreamName=stream_name,
                    Data=json.dumps(value),
                    PartitionKey=str(key))
                print("key:{0}, value:{1}".format(key, value))
        except KeyboardInterrupt:
            break

    consumer.close()


if __name__=="__main__":
    kinesis_client = boto3.client('kinesis', region_name=os.environ.get("AWS_REGION"))
    stream_name = os.environ.get("KINESIS_STREAM_NAME")
    get_data(kinesis_client, stream_name)