FROM python:3.9-slim-bullseye

RUN apt-get -y update && \
  pip install --upgrade pip && \
  pip install langchain && \
  pip install langchain_openai && \
  pip install "langserve[all]" && \
  pip install datasets && \
  pip install faiss-cpu && \
  pip install beautifulsoup4 && \
  pip install langchainhub && \
  pip install langchain-cli && \
  pip install langsmith && \
  pip install pydantic==1.10.13

WORKDIR /app

CMD ["python3"]