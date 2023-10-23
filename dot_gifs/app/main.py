from logging.config import dictConfig
import os

import yaml
from flask import Flask
from flask import render_template


dictConfig(
    {
        "version": 1,
        "formatters": {
            "default": {
                "format": "[%(asctime)s] %(levelname)s in %(module)s: %(message)s",
            }
        },
        "handlers": {
            "wsgi": {
                "class": "logging.StreamHandler",
                "stream": "ext://flask.logging.wsgi_errors_stream",
                "formatter": "default",
            }
        },
        "root": {"level": "INFO", "handlers": ["wsgi"]},
    }
)

app = Flask(__name__)


def retrieve_gif_list():
    ret = {}
    with open(os.path.join(os.path.dirname(__file__), "gifs.yml"), "r") as fh:
        yml = yaml.safe_load(fh)
        for v in yml["gifs"]:
            ret.update(v)

    return ret


GIFS = retrieve_gif_list()


@app.route("/")
def root():
    return render_template("index.html", gifs=GIFS)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
