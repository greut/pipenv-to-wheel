from flask import Flask, make_response
app = Flask(__name__)

@app.route("/")
def hello():
    return make_response("""\
<!DOCTYPE html>
<meta charset="utf-8">
<title>Flask is fun</title>
<img src="flask.png" alt="Flask">""")

if __name__ == "__main__":
    app.run()
