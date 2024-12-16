import logging
import boto3
from flask import Flask, render_template

app = Flask(__name__)

# Configure CloudWatch logging
logger = logging.getLogger('application-logger')
logger.setLevel(logging.INFO)

# Stream logs to AWS CloudWatch
log_group_name = "YourAppLogGroup"
log_stream_name = "ApplicationLogs"

# Initialize boto3 client
client = boto3.client('logs', region_name='your-region')  # Replace 'your-region'

# Create log group and stream if they don't exist
try:
    client.create_log_group(logGroupName=log_group_name)
except client.exceptions.ResourceAlreadyExistsException:
    pass

try:
    client.create_log_stream(logGroupName=log_group_name, logStreamName=log_stream_name)
except client.exceptions.ResourceAlreadyExistsException:
    pass

# Define a logging handler for CloudWatch
class CloudWatchHandler(logging.Handler):
    def emit(self, record):
        log_event = {
            'logGroupName': log_group_name,
            'logStreamName': log_stream_name,
            'logEvents': [
                {
                    'timestamp': int(record.created * 1000),
                    'message': self.format(record)
                }
            ]
        }
        client.put_log_events(**log_event)

cloudwatch_handler = CloudWatchHandler()
logger.addHandler(cloudwatch_handler)

@app.route('/')
def home():
    logger.info("Home endpoint accessed.")
    return render_template('index.html')

@app.route('/version')
def version():
    logger.info("Version endpoint accessed.")
    return "v1.0.0"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
