# vim:set ft=dockerfile:

FROM ubuntu:focal as pipenv

SHELL ["/bin/bash", "-xe", "-c"]

COPY . /app/hello-world
WORKDIR /app/hello-world

RUN apt-get update -q \
 && apt-get install -q -y --no-install-recommends \
        git \
        pipenv \
 && pipenv install --dev \
 && pipenv lock -r > requirements.txt \
 && pipenv run python setup.py sdist \
 && pipenv run python setup.py bdist_wheel

# ----------------------------------------------------------------------------
FROM ubuntu:focal

SHELL ["/bin/bash", "-xe", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=pipenv /app/hello-world/dist/*.whl .

RUN apt-get update -q \
 && apt-get install -y -q --no-install-recommends \
        python3-minimal \
        python3-wheel \
        python3-pip \
        gunicorn \
 && python3 -m pip install *.whl \
 && apt-get remove -y python3-pip python3-wheel \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && rm -f *.whl \
 && rm -rf /root/.cache \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /app \
 && useradd _gunicorn --no-create-home --user-group

USER _gunicorn
ADD static /app/static
WORKDIR /app

CMD ["gunicorn", \
     "--bind", "0.0.0.0:8000", \
     "hello_world:app"]
