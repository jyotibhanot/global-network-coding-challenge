import flask
import requests

app = flask.Flask(__name__)
@app.route("/")
def hello():
    resp = flask.Response('Hello World!')
    response = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
    ins_id = response.text
    resp.headers['InstanceId'] = ins_id
    return resp
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

