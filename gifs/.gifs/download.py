#! /usr/bin/env python
"""This script downloads GIFs in order to always have my stock up to date on all my computers"""

import argparse
import logging
import os
import time
import threading
from typing import AnyStr, List

import requests
import yaml


logger = logging.getLogger('gif-downloader')

def retrieve_gif_list():
    ret = {}
    with open(os.path.join(os.path.dirname(os.path.dirname(__file__)), 'gifs.yml'), 'r') as fh:
        yml = yaml.safe_load(fh)
        for v in yml['gifs']:
            ret.update(v)

    return ret

def configure_logger(debug=False):
    """Configure the logger"""
    logger.setLevel(logging.DEBUG if debug else logging.INFO)

    # create console handler and set level to debug
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG if debug else logging.INFO)

    # create formatter
    formatter = None
    fmt = '%(asctime)s - %(name)s - %(threadName)s - %(levelname)s - %(message)s'
    try:
        import coloredlogs
        formatter = coloredlogs.ColoredFormatter(fmt)
    except ImportError:
        formatter = logging.Formatter(fmt)

    # add formatter to ch
    for handler in [ch]:
        handler.setFormatter(formatter)

        # add ch to logger
        logger.addHandler(handler)


def chunks(lst: List, split_nb: int) -> List[List]:
    """Generator that yields the chunks you want"""
    if lst:
        step = int(len(lst) / split_nb + 0.5)
        # step = int((len(lst) / split_nb) // 1) + 1
        logger.debug("%d / %d = %d", len(lst), split_nb, step)
        for i in range(0, len(lst), step):
            yield lst[i:i+step]


class DownloaderThread(threading.Thread):
    """Thread that download a list of file"""

    def __init__(self, keys_list: list, gifs: dict, id: int):
        super().__init__(name=f'Thread {id}')
        self._keys_list = keys_list
        self._gifs = gifs

    def run(self):
        for key in self._keys_list:
            logger.info("Downloading %s.gif", key)

            with open(f'{key}.gif', 'wb') as fh:
                resp = requests.get(self._gifs[key], allow_redirects=True)
                fh.write(resp.content)
                logger.debug("Downloaded %s.gif (%d bytes)", key, len(resp.content))


def check_gif_exists(gif_names: List[AnyStr]):
    """Check if the GIF has already been downloaded and add it to list if it does not."""
    l = []
    for gif_name in gif_names:
        if os.path.exists(f'{gif_name}.gif'):
            logger.debug(f'GIF {gif_name} already exists. Passing')
            continue
        l.append(gif_name)

    return l

def main():
    parser = argparse.ArgumentParser(description="Download my gifs")
    parser.add_argument('-d', '--debug', action='store_true', help="Show debug log traces")
    args = parser.parse_args()

    configure_logger(debug=args.debug)

    gifs = retrieve_gif_list()
    thread_pool = []
    thread_arg_list = chunks(check_gif_exists(list(gifs.keys())), 8)

    # Create ResultsWriterThread and store them in the pool
    for id, thread_arg in enumerate(thread_arg_list):
        result_thread = DownloaderThread(thread_arg, gifs, id)
        result_thread.start()
        thread_pool.append(result_thread)

    for thread in thread_pool:
        thread.join()

    logger.debug("All jobs are done")


if __name__ == '__main__':
    main()
