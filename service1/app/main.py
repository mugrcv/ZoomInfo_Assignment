from flask import Flask
import urllib3
app = Flask(__name__)

@app.route("/")
def hello():
    url = 'http://service2.internal.net'
    http = urllib3.PoolManager()
    resp = http.request('GET', url)
    return (resp.data.decode('utf-8'))

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=80)
