# test ETL ingress with SQL Server
from os import read
import pyodbc
import sys
from split_sql import split_sql_expressions as split_sql
from read_config import ConfigReader
from static import StaticMethods


class Main(object):
    CONFIG = None
    CONFIG_PATH = None
    FILE = None
    CONNECTION_STRING = None

    @classmethod
    def set_config(cls, config):
        cls.CONFIG = config
        return

    @classmethod
    def get_config(cls):
        return cls.CONFIG

    @classmethod
    def set_file(cls, file):
        cls.FILE = file
        return

    @classmethod
    def get_file(cls):
        return cls.FILE

    @classmethod
    def initiate(cls, file, config):
        cls.CONFIG_PATH = config
        print("INITIATING...")
        cls.FILE = file

        if config.endswith('.json'):
            cls.CONFIG = ConfigReader.read_json(file_path=config)
        elif config.endswith('.yaml'):
            cls.CONFIG = ConfigReader.read_yaml(file_path=config)
        else:
            raise Exception("Please pass either a JSON or YAML configuration file.")
        print("Setting CONNECTION STRING...")
        cls.CONNECTION_STRING = f'DRIVER={cls.CONFIG["DRIVER"]};SERVER=' + cls.CONFIG["SERVER"] + \
                                    ';DATABASE=' + cls.CONFIG["DATABASE"] + ';Trusted_connection=yes'
        print("Connection String: ", cls.CONNECTION_STRING)

    @classmethod
    def query(cls, query):
        print(cls.CONNECTION_STRING)
        connection = pyodbc.connect(cls.CONNECTION_STRING, autocommit=True)
        cursor = connection.cursor()
        try:
            cursor.execute(query)
        except Exception as ERROR:
            raise

        cursor.close()
        connection.close()

    @classmethod
    def create_database(cls, name):
        print("Creating Database...")
        query = f"CREATE DATABASE {name};"
        cls.query(query)

        try:
            cls.CONFIG["DATABASE"] = name
        except:
            print("There was an error adjusting your configuration. Please make sure you modify your "\
                    "configuration file manually to include the database you created. ")
            raise
        print("DONE.")

    @classmethod
    def switch_database(cls, name):
        print("Modifying procedure Database...")
        StaticMethods.modify_file_line("procedure.sql", "USE", f"USE {name};")

        cls.CONFIG["DATABASE"] = name
        import time
        ConfigReader.update_json(cls.CONFIG, cls.CONFIG_PATH)
        print("DONE")
        print("Now please run the procedure.sql script to initiate the "\
                "procedure within the targeted database before using again.")

    @classmethod
    def create_procedure(cls):
        with open("procedure.sql", "r") as script:
            for stmt in split_sql(script.read()):
                cls.query(stmt)
        # print("SQL: ", sql)
        # cls.query(sql)

    @classmethod
    def execute(cls):
        print("executing..")
        query = f"EXEC dbo.pokemonIngress @File = N'{file}';"
        try:
            cls.query(query)
            print("DONE.")
        except pyodbc.ProgrammingError as ERROR:
            print("Procedure doesn't exist... creating it...")
            cls.create_procedure()
            cls.query(query)


if __name__ == "__main__":
    file = sys.argv[1]
    config = sys.argv[2]

    Main.initiate(file, config)

    # Create and update database information
    # Requires you to re-run `procedure.sql`
    # Main.create_database("updated3")
    # Main.switch_database("updated3")

    Main.execute()

