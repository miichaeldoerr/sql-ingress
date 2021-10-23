import json
import logging
import datetime
from static import StaticMethods


__author__ = "Michael Robert Doerr"
__maintainer__ = 'Michael Robert Doerr'
__credits__ = ['Michael Robert Doerr']
__email__ = 'mike.doerrx@gmail.com'
__status__ = ''
__copyright__ = ''
__version__ = '1.0.0'


StaticMethods.handle_directory("logs/database")
logging.basicConfig(filename='logs/{}-log.log'.format(datetime.datetime.now().strftime("%Y-%m-%d.%H.%M.%S")), level=logging.DEBUG)

class ConfigReader(object):
    
    @staticmethod
    def read_json(file_path="config.json"):
        try:
            with open(file_path, "r") as f:
                try:
                    json_loaded = json.load(f)
                    logging.info("-----  {}  ----- Loaded the configuration successfully.".format(datetime.datetime.now()))
                    return json_loaded

                except json.decoder.JSONDecodeError as ERROR:
                    print("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
                    logging.error("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
                    raise
            
        except FileNotFoundError as ERROR:
            print("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
            logging.error("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
            raise

    @staticmethod
    def update_json(new_json, file_path="config.json"):
        try:
            with open(file_path, "w") as f:
                try:
                    json.dump(new_json, f, indent=4)
                    return

                except json.decoder.JSONDecodeError as ERROR:
                    print("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
                    logging.error("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
                    raise
            
        except FileNotFoundError as ERROR:
            print("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
            logging.error("-----  {}  ----- {}".format(datetime.datetime.now(), ERROR))
            raise

    @staticmethod
    def read_yaml(file_path="config.yaml"):
        print("Please wait.")
        pass