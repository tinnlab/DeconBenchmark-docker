ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN pip3 --no-cache-dir install ARIC

COPY run.py /code/

CMD ["python3", "/code/run.py"]