# syntax = docker/dockerfile:1

# Define Python version (adjust as needed)
ARG PYTHON_VERSION=3.8.10

# Base image with Python
FROM python:$PYTHON_VERSION-slim as base

# Work directory for your Python application
WORKDIR /workspaces/dockerfile

# Install essential packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev

# Install your Python dependencies (replace with your actual commands)
COPY requirements.txt ./
RUN pip install -r requirements.txt

RUN apt-get install git -y

# Install "populartimes" library from the submodule
COPY --link populartimes/ /workspaces/dockerfile/populartimes


RUN git submodule update

RUN cd populartimes && git submodule init




RUN sys.path.append('/workspaces/dockerfile/populartimes')

# Copy your Python application code
COPY get_busy_times.py .

# Expose port for your application
EXPOSE 5000

# Entrypoint command to run your Python app (replace with your script)
ENTRYPOINT ["python", "get_busy_times.py"]

# Default command to start the server (can be overridden)
CMD ["python", "get_busy_times.py"]
