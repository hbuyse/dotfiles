from flask import Flask
from flask import render_template

import os
import yaml


app = Flask(__name__)

def retrieve_gif_list():
    ret = {}
    with open( os.path.join(os.path.dirname(__file__), "gifs.yml"), "r") as fh:
        yml = yaml.safe_load(fh)
        for v in yml["gifs"]:
            ret.update(v)

    return ret

GIFS = retrieve_gif_list()

@app.route("/")
def root():
    return render_template("index.html", gifs=GIFS)
