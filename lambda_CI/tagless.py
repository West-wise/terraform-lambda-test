import json
import os
import boto3

s3 = boto3.client('s3')

def tag_bucket(bucketName, key, file_download_path):
    try:
        # Calculate the file size
        #file_size_bytes = os.path.getsize(file_download_path)
        #file_size_KB = file_size_bytes / 1024
        
        # stat 명령어를 사용하여 파일 크기를 구합니다.
        output = os.system("stat -c %s " + file_download_path)

        # 출력에서 파일 크기를 추출합니다.
        file_size_KB = output

        # Add tags to the S3 object
        s3.put_object_tagging(
            Bucket=bucketName,
            Key=key,
            Tagging={
                'TagSet': [
                    {
                        'Key': 'file_path',
                        'Value': file_download_path,
                    },
                    {
                        'Key': 'file_size_KB',
                        'Value': file_size_KB,
                    },
                ]
            }
        )
    except Exception as e:
        print(f"Failed to tag file: {e}")

def lambda_handler(event, context):
    object_key = event['Records'][0]['s3']['object']['key']
    file_download_path = f'/tmp/{object_key.split("/")[-1]}'
    bucketName = event['Records'][0]['s3']['bucket']['name']
    fileKey = event['Records'][0]['s3']['object']['key']

    try:
        s3.download_file(bucketName, fileKey, file_download_path)
        tag_bucket(bucketName, fileKey, file_download_path)
    except Exception as e:
        print(f"Failed to process file: {e}")

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'File tagged successfully'}),
    }
