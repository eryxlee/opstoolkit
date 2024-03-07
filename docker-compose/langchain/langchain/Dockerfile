FROM python:3.9-slim-bullseye

RUN apt-get -y update && \
  pip install --upgrade pip && \
  pip install langchain && \
  pip install langchain_openai && \
  pip install "langserve[all]" && \
  pip install datasets && \
  pip install faiss-cpu

WORKDIR /app

CMD ["python3"]