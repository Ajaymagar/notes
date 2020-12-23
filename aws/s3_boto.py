import boto3
from botocore.client import Config

ACCESS_KEY_ID  = ''
ACCESS_SECRET_KEY = ''
bucket_name = ''
data = open('test.png','rb')

s3 = boto3.resource('s3',aws_access_key_id=ACCESS_KEY_ID, 
aws_secret_access_key=ACCESS_SECRET_KEY,config=Config(signature_version='s3v4'))

s3.Bucket(bucket_name).put_object(Key='test.png',Body=data)

print('done')