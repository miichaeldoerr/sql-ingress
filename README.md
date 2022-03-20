<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->







<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h1 align="center">Transact SQL Ingress Solution</h1>

  <p align="center">
    Read below to learn more about the project.
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This simple solution using T-SQL, which extracts JSON data into a temporary SQL table, creates the necessary tables and loads the structured data into them corresponding table. Resulting in an organized structured SQL database.

The benefit of this solution may be based off ease of use for the user. This project solution is dynamic besides the T-SQL script. To apply this to other datasets, simply modify the `procedure.sql` accordingly.

More features including YAML configuration support and different data file structures will be developed in the future.

Please reach out to me if you have any advice or questions regarding the project.

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

Here is a list of the languages and major libraries used within this project:

* [Python](https://www.python.org/)
* [SQL Server](https://www.microsoft.com/en-ca/sql-server/sql-server-downloads)
* [pyodbc](https://pypi.org/project/pyodbc/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

See the instruction below for getting started with the project.

### Prerequisites

What you will need before getting started:

* SQL Server

     * See downloads [here](https://www.microsoft.com/en-ca/sql-server/sql-server-downloads).

* Python

     * See the official Python webpage [here](https://www.python.org/)

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/miixel/sql-ingress.git
   ```
2. Set up a virtual environment with Python
   ```sh
   python -m venv venv
   ```
3. Install requirements.txt
   ```sh
   pip install -r requirements.txt
   ```

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

To load the JSON data from the folder 'data', do the following:

1. Set up your configuration to match the following

        {
                "SERVER": "localhost,
                "DATABASE": "",
                "DRIVER": "ODBC Driver 17 for SQL Server"
        }

2. Run the script `procedure.sql`.

     2. Modify the files USE statement if necessary to the target database of your choice, keep in mind this can also be done by importing Main from main and calling Main.switch_database(), keep reading for more details.

3. ...

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Name - Michael Doerr

Email - miichael.doerr@gmail.com

Project Link: [https://github.com/miixel/sql-ingress.git](https://github.com/miixel/sql-ingress.git)

<p align="right">(<a href="#top">back to top</a>)</p>


