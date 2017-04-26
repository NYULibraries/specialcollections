FROM solr:5.5.4

ADD conf/ /tmp/conf

RUN /opt/solr/bin/solr start && \
    /opt/solr/bin/solr create_core -c development-core -d /tmp/conf && \
    /opt/solr/bin/solr create_core -c test-core -d /tmp/conf && \
    /opt/solr/bin/solr stop
