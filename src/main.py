import vt
import os
from google.cloud import storage



def virus_scanner(data, context):
    VirusTotal_API_KEY = os.environ.get('VirusTotal_API_KEY')
    bucket_name = data['bucket']
    file_name = data['name']

    # Saving the file temporarily
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    file_path = f'/tmp/{file_name}'

    blob = bucket.blob(file_name)
    generation_match_precondition = None
    blob.download_to_filename(file_path)

    # Using VirusTotal for scanning
    client = vt.Client(VirusTotal_API_KEY)
    with open(file_path, "rb") as f:
        analysis = client.scan_file(f, wait_for_completion=True)
    if analysis.stats['malicious'] > 0 :
        result = f"{file_name} detected with virus, item it being deleted..."
        # Deletes file from bucket if a virus detected
        blob.reload()
        generation_match_precondition = blob.generation
        blob.delete(if_generation_match=generation_match_precondition)
        print(result)
    else :
        result = 'no viruses detected'
        print(result)
    client.close()

    return result