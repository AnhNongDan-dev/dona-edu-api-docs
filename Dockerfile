FROM node:20-alpine

WORKDIR /app

RUN npm i -g @stoplight/prism-cli

COPY src/openapi.yaml /app/openapi.yaml

EXPOSE 4010

CMD ["prism", "mock", "/app/openapi.yaml", "-h", "0.0.0.0", "-p", "4010", "--cors"]