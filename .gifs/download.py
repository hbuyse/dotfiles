#! /usr/bin/env python

import logging
import time
import threading
import requests

from typing import List

logger = logging.getLogger('gif-downloader')

start_time = time.time()

URLS = {
    'bartender_beer':"https://media.giphy.com/media/h8NdYZJGH1ZRe/giphy-downsized.gif",
    'boom_anna_kendrick':"https://media.giphy.com/media/laUY2MuoktHPy/giphy.gif",
    'c_est_pas_faux':"https://media1.tenor.com/images/9e2fd8f6f208f6e34a01038859a10b0b/tenor.gif",
    'c_est_ma_bite_qpuc':"https://media1.tenor.com/images/315796b8dec7046c24c73e983f6854ed/tenor.gif",
    'coffee_coin':"https://media.giphy.com/media/NHUONhmbo448/giphy.gif",
    'come_at_me_penguin':"https://media.giphy.com/media/U7GRtzqJMyVEs/giphy.gif",
    'dancing_oss117':"https://media1.tenor.com/images/4e17dc669ec43adf82da9458ca248efe/tenor.gif",
    'dancing_bambino_oss117':"https://media1.tenor.com/images/85beaf83f7c00910ab22cded382772d7/tenor.gif",
    'dancing_rabbids':"https://media.giphy.com/media/OScDfyJIQaXe/giphy-downsized.gif",
    'dog_patting':"https://media.giphy.com/media/l1LbUHrJb7GpuOHK0/giphy.gif",
    'drum_roll':"https://media1.tenor.com/images/f282743438fcb3fd7d57fd8506e06749/tenor.gif",
    'embarassed_korean':"https://media.giphy.com/media/K1QnLV1caRpuw/giphy-downsized.gif",
    'embarassed_reaction':"https://media.giphy.com/media/3o7btUg31OCi0NXdkY/giphy.gif",
    'explosion_nuclear':"https://media.giphy.com/media/HhTXt43pk1I1W/giphy-downsized.gif",
    'facepalm':"https://media.giphy.com/media/3og0INyCmHlNylks9O/giphy.gif",
    'git_merge':"https://media.giphy.com/media/cFkiFMDg3iFoI/giphy.gif",
    'good_job_computer':"https://media.giphy.com/media/XreQmk7ETCak0/giphy.gif",
    'good_job_rugby':"https://media.giphy.com/media/l378zfJZhyrFQX8EE/giphy-downsized.gif",
    'groscailloux': "https://c.tenor.com/2C8HVGtIAFkAAAAC/groscailloux-leskassos.gif",
    'hallelujah_big_bang_theory':"https://media.giphy.com/media/KAS81mpeo9kkw/giphy.gif",
    'hallelujah_bunny_dance':"https://media.giphy.com/media/MahDrOWLffiMKpiVV0/giphy-downsized.gif",
    'hello_bear':"https://media.giphy.com/media/IThjAlJnD9WNO/source.gif",
    'hello_coffee':"https://media.giphy.com/media/SYM0DZzld3dBOy1gBt/giphy-downsized.gif",
    'hello_jim_carrey':"https://media.giphy.com/media/PK1YQhAoBOpP2/giphy.gif",
    'hello_there_star_wars':"https://media.giphy.com/media/Nx0rz3jtxtEre/giphy-downsized.gif",
    'hello_there_whale':"https://media.giphy.com/media/mW05nwEyXLP0Y/source.gif",
    'hello_tom_hanks':"https://media.giphy.com/media/xT9IgG50Fb7Mi0prBC/giphy.gif",
    'hello_teleboobies':"https://media1.tenor.com/images/44b38d55109e7be164f75e6651993b7f/tenor.gif",
    'kiss_flirt_shaq':"https://media.giphy.com/media/10UUe8ZsLnaqwo/giphy.gif",
    'la_bamboche_c_est_termine':"https://media1.tenor.com/images/3cbe185deac4a7c5787f9bd0e9abe759/tenor.gif",
    'lapin_metro_kassos':"https://media1.tenor.com/images/32fcbeadbbfa7746d1f5a5d2acd633a0/tenor.gif",
    'marteau_piqueur':"https://media.giphy.com/media/TLmFNeMSrOw2VxZGvI/giphy-downsized.gif",
    'mindblowing':"https://media.giphy.com/media/xT0xeJpnrWC4XWblEk/giphy-downsized.gif",
    'minions_booty_bum':"https://media1.tenor.com/images/d30c56b02b29cf801d8e7eda27e541d3/tenor.gif",
    'minions_kiss':"https://media1.tenor.com/images/131b59c8710f085956f956524ce632c8/tenor.gif",
    'nan_mais_oh_oss117':"https://media1.tenor.com/images/a4815b3cb29fd15743f1e6ab5008924d/tenor.gif",
    'ninja': "https://media.giphy.com/media/3ohhwytHcusSCXXOUg/giphy-downsized.gif",
    'no_mario': "https://media1.tenor.com/images/1526fcedf71caea22b265c0aa528c0bc/tenor.gif",
    'no_starwars': "https://media.giphy.com/media/10rHZ6K9jYvLUc/giphy.gif",
    'nuclear_explosion':"https://media.giphy.com/media/HhTXt43pk1I1W/giphy-downsized.gif",
    'oh_shit_cartoon':"https://media.giphy.com/media/vwI4mYEHP8k0w/giphy.gif",
    'oh_my_god':"https://media.giphy.com/media/TgOYjtgKpS9jAytUlh/giphy-downsized.gif",
    'oss117_d_accord':"https://media1.tenor.com/images/cd42ce11f3382d97a68a107180b13236/tenor.gif",
    'oss117_mambo':"https://media1.tenor.com/images/4e17dc669ec43adf82da9458ca248efe/tenor.gif",
    'panic_bigbangtheory':"https://media.giphy.com/media/1FMaabePDEfgk/giphy.gif",
    'panic_minions':"https://media.giphy.com/media/lKZEeXJGhU1d6/giphy.gif",
    'panic_spongebob':"https://media.giphy.com/media/HUkOv6BNWc1HO/giphy.gif",
    'pas_content_mission_cleopatra':"https://media1.tenor.com/images/eda439a0e40ec1762c34e5606750691c/tenor.gif",
    'pas_content_marmotte':"https://media.giphy.com/media/EIOdxsJ7faTSr408OM/giphy.gif",
    'perfect_italian_carl_simpson.gif':"https://media.giphy.com/media/3o8doT9BL7dgtolp7O/giphy.gif",
    'perfect_hugh_grant':"https://media.giphy.com/media/UR2r2iWXjq65O/giphy.gif",
    'pretty_please_alison_brie':"https://media.giphy.com/media/hB8fe00fafdmM/giphy-downsized.gif",
    'pretty_please_puss_in_boots':"https://media.giphy.com/media/qUIm5wu6LAAog/giphy.gif",
    'pretty_please_rabbids':"https://media.giphy.com/media/l3vR99gV3GJzsPcfC/giphy-downsized.gif",
    'pssst':"https://media.giphy.com/media/LNw7PmZTB6z4kstTnO/giphy-downsized.gif",
    'rameur':"https://media.giphy.com/media/1figSjF4pYLhS/giphy.gif",
    'rower_head':"https://media.giphy.com/media/hGr6QFua3JuVO/giphy.gif",
    'scared_scream_queens':"https://media.giphy.com/media/Ej0sZ2rPd2uXu/giphy.gif",
    'scared_timon_pumba':"https://media.giphy.com/media/KmTnUKop0AfFm/giphy.gif",
    'seal_beer':"https://media1.tenor.com/images/d393e5444c18f29e9147759d6606fe6e/tenor.gif",
    'seal_with_it':"https://media.giphy.com/media/B86lxbrMSZ0SQ/giphy.gif",
    'ship_it_hyperrpg':"https://media.giphy.com/media/5bvPqNqk9WVCpYPH1q/giphy-downsized.gif",
    'ship_it_sign':"https://media.giphy.com/media/4ZgwMNUYMxHIyFXujF/giphy-downsized.gif",
    'ship_it_thore':"https://media.giphy.com/media/HkA9xsCxJCRWw/giphy.gif",
    'shake_your_booty_donald':"https://media.giphy.com/media/7E3dz83Pvtdmg/giphy.gif",
    'shocked_james_franco':"https://media.giphy.com/media/vA5evXPactVhC/giphy.gif",
    'shocked_meme':"https://media.giphy.com/media/cF7QqO5DYdft6/giphy.gif",
    'shocked_nba':"https://media.giphy.com/media/l3q2SaisWTeZnV9wk/giphy.gif",
    'speechless_castle':"https://media.giphy.com/media/y7kvOYLzas6Ag/giphy-downsized.gif",
    'so_cute_zootopia':"https://media1.tenor.com/images/660add573073e24e67817220aaf99307/tenor.gif",
    'so_hot_korean': "https://media.giphy.com/media/l0ErF5NVjqvvquRna/giphy.gif",
    'super_sayan':"https://media.giphy.com/media/mXz3v0UdjrNTO/giphy.gif",
    'thank_you_the_office':"https://media.giphy.com/media/5xtDarmwsuR9sDRObyU/giphy-downsized.gif",
    't_es_mauvais_oss117':"https://media1.tenor.com/images/a21a28d1e2bb341d7ef7ddd4e8908b37/tenor.gif",
    'this_is_fine':"https://media.giphy.com/media/QMHoU66sBXqqLqYvGO/giphy.gif",
    'weekend_minions':"https://media.giphy.com/media/lqFY9hBTLX7os/giphy.gif",
    'weekend_rabbids':"https://media.giphy.com/media/l2JhBoNin9yhqSDLO/giphy.gif",
    'whats_up_seal':"https://media.giphy.com/media/ypqHf6pQ5kQEg/giphy.gif",
    'yeah':"https://media.giphy.com/media/MSS0COPq80x68/giphy.gif",
    'you_can_do_it':"https://media.giphy.com/media/mmtLWZVKLOqOs/giphy.gif",
    'you_shall_not_pass':"https://media.giphy.com/media/njYrp176NQsHS/source.gif"
}


def chunks(lst: List, split_nb: int) -> List[List]:
    """Generator that yields the chunks you want"""
    if not lst:
        return lst

    step = int(len(lst) / split_nb + 0.5)
    # step = int((len(lst) / split_nb) // 1) + 1
    logger.debug("{} / {} = {}".format(len(lst), split_nb, step))
    for i in range(0, len(lst), step):
        yield lst[i:i+step]


class DownloaderThread(threading.Thread):

    def __init__(self, keys_list: list, id: int):
        super().__init__()
        self._id = id
        self._keys_list = keys_list

    def run(self):
        for key in self._keys_list:
            logger.warning("Downloading {}.gif".format(key))

            url = URLS[key]

            with open('{}.gif'.format(key), 'wb') as fh:
                r = requests.get(url, allow_redirects=True)
                fh.write(r.content)


def main():
    thread_pool = list()
    thread_arg_list = chunks(list(URLS.keys()), 8)

    # Create ResultsWriterThread and store them in the pool
    for id, thread_arg in enumerate(thread_arg_list):
        result_thread = DownloaderThread(thread_arg, id)
        result_thread.start()
        thread_pool.append(result_thread)

    for thread in thread_pool:
        thread.join()

    logger.debug("All jobs are done")


if __name__ == '__main__':
    main()
