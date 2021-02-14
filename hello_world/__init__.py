from flask import Flask, make_response
from whitenoise import WhiteNoise


app = Flask(__name__)

app.wsgi_app = WhiteNoise(app.wsgi_app, root='static/')


@app.route("/")
def hello():
    return make_response("""\
<!DOCTYPE html>
<meta charset="utf-8">
<title>Flask is fun</title>
<img src="flask.png" alt="Flask">""")


if __name__ == "__main__":
    app.run()
