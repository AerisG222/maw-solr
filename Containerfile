FROM alpine

RUN apk --no-cache add curl

WORKDIR /
RUN curl https://jdbc.postgresql.org/download/postgresql-42.2.18.jar --output postgresql-42.2.18.jar


FROM solr

COPY --from=0 /postgresql-42.2.18.jar /opt/solr/contrib/dataimporthandler/lib/
