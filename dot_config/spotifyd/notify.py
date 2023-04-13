#!/usr/bin/env python3
# coding: utf-8

import json
import logging
import os
import sqlite3
import time

import dbus
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials

import yaml

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

def get_authentication():
    """Get authentification from the spotify-tui client"""
    with open(f"{SCRIPT_DIR}/../spotify-tui/client.yml", "rb") as f:
        data = yaml.load(f, Loader=yaml.CLoader)
        return data['client_id'], data['client_secret']

def notify(data):
    ITEM = "org.freedesktop.Notifications"
    notify_interface = dbus.Interface(dbus.SessionBus().get_object(ITEM, "/" + ITEM.replace(".", "/")), ITEM)

    if data["event"] == "volumeset":
        notify_interface.Notify("spotifyd", 0, "Spotify", data["event"], str(data["volume"]),
                                [], {"urgency": 1, "suppress-sound": True, "value": data["volume"]}, 1000)
        return

    notify_interface.Notify("spotifyd",
                            0,
                            "Spotify",
                            f"{data['event']} - {data['source']}",
                            f"{data['song']} by {data['artists']}\nAlbum: {data['album']}",
                            [],
                            {
                                "urgency": 1,
                                "suppress-sound": True,
                                "value": data["percentage"] if "percentage" in data else 0
                            },
                            3000)


def main():
    # Create SQLite database to store data instead of making requests
    conn = sqlite3.connect(f'{SCRIPT_DIR}/spotifyd_tracks.sqlite3')
    c = conn.cursor()
    c.execute('''
              CREATE TABLE IF NOT EXISTS songs
              ([song_id] TEXT PRIMARY KEY, [song_name] TEXT, [song_artists] TEXT, [song_album] TEXT);
              ''')

    conn.commit()
    event = os.getenv("PLAYER_EVENT")

    assert(event is not None)

    if event not in ["play", "pause"]:
        return

    data = {
        "event": event
    }

    # {"PLAYER_EVENT": "play", "POSITION_MS": "0", "DURATION_MS": "246000", "PLAY_REQUEST_ID": "7", "TRACK_ID": "0fzmEpLBvEBVXXIBFlMKoU"}
    # {"PLAYER_EVENT": "change", "OLD_TRACK_ID": "1zlbeVYcTnlW8fSCCBiTfj", "TRACK_ID": "0fzmEpLBvEBVXXIBFlMKoU"}
    # {"PLAYER_EVENT": "endoftrack", "TRACK_ID": "1zlbeVYcTnlW8fSCCBiTfj", "PLAY_REQUEST_ID": "6"}
    # {"PLAYER_EVENT": "preloading", "TRACK_ID": "0fzmEpLBvEBVXXIBFlMKoU"}
    # {"PLAYER_EVENT": "volumeset", "VOLUME": "58982"}
    if event == "volumeset":
        data.update({  # type: ignore
            "volume": int(int(os.getenv("VOLUME")) / 65535 * 100)  # type: ignore
        })
    else:
        position = int(os.getenv("POSITION_MS", "0")) / 1000
        duration = int(os.getenv("DURATION_MS", "0")) / 1000

        data.update({  # type: ignore
            "trackid": os.getenv("TRACK_ID", ""),
            "oldtrackid": os.getenv("OLD_TRACK_ID", ""),
            "playrequestid": int(os.getenv("PLAY_REQUEST_ID", "0")),
            "position": time.strftime("%M:%S", time.gmtime(position)),
            "duration": time.strftime("%M:%S", time.gmtime(duration)),
        })

        if position and duration:
            data['percentage'] = int(position / duration * 100)  # type: ignore

    data["event"] = event.title()

    if "trackid" in data:
        query = f"SELECT song_name, song_artists, song_album FROM songs WHERE song_id=\"{data['trackid']}\";"
        result = c.execute(query).fetchall()
        if not result:
            client_id, client_secret = get_authentication()
            spotify = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id, client_secret))
            results = spotify.track(data["trackid"], market="FR")
            data["source"] = "spotipy"

            if results:
                data["song"] = results["name"]
                data["album"] = results["album"]["name"]
                data["artists"] = ', '.join([artist["name"] for artist in results["artists"]])

                c.execute(f"""
                          INSERT INTO songs (song_id, song_name, song_artists, song_album)
                          VALUES ("{data['trackid']}", "{data['song']}", "{data['artists']}", "{data['album']}");
                          """)
                conn.commit()

        else:
            data["song"] = result[0][0]
            data["artists"] = result[0][1]
            data["album"] = result[0][2]
            data["source"] = "database"

    if data['event'] not in ['volumeset', "preloading", "load"]:
        notify(data)

if __name__ == "__main__":
    main()
