# diagram.py
from diagrams import Diagram, Cluster
from diagrams.programming.language import Python
from diagrams.programming.framework import Flask
from diagrams.onprem.container import Docker
from diagrams.onprem.vcs import Git
from diagrams.gcp.devtools import GCR
from diagrams.gcp.devtools import Build
from diagrams.gcp.compute import Run
from diagrams.gcp.operations import Monitoring

with Diagram(filename="weather_app", show=False):

    with Cluster("WebApp"):
        python = Python("WeatherApp")
        flask = Flask("Flask")

    with Cluster("Cloud Infra"):
        gcr = GCR("Artifact")
        build = Build("Build")
        run = Run("Deployment")
        monitoring = Monitoring("Monitoring")

    python >> flask >> Git("Version control") >> Docker("Containerize") >> gcr >> build >> run << monitoring
