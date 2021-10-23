import os
import logging
import datetime


__author__ = "Michael Robert Doerr"
__copyright__ = 'Copyright 2021-2022, Cucumber Project, Vineland Research and Innovation Centre'
__version__ = '1.0.0'
__maintainer__ = 'Michael Robert Doerr'
__credits__ = ['Michael Robert Doerr']
__email__ = 'mike.doerr@vinelandresearch.com'
__status__ = 'Pre-Production/Development'


class StaticMethods(object):

    @staticmethod
    def handle_directory(file):
        """ Checks if the path directory exists, if not, it creates it. """
        if not os.path.isdir(file):
            print("Creating the directory '{}'...".format(file))
            try:
                os.makedirs(file)
            except Exception as ERROR:
                logging.error("--- {} --- {}".format(datetime.datetime.now(), ERROR))
                raise
            print("Done.")
        else:
            pass

        return

    @staticmethod
    def modify_file_line(file, target, new):
        read_file = open(file, "r")
        new_file_data = ""

        for line in read_file:
            if target in line:
                new_line = new + "\n"
            else:
                new_line = line
            new_file_data += new_line
        read_file.close()

        write_file = open(file, "w")
        write_file.write(new_file_data)
        write_file.close()

        return