FROM golang as builder
RUN go get -u github.com/google/pprof


FROM python:3.7.3

RUN apt update
RUN apt install graphviz -y

EXPOSE 7007
COPY ./ /profiler-ui
WORKDIR /profiler-ui

COPY --from=builder /go/bin/pprof /usr/bin/pprof

RUN pip install -r requirements.txt

RUN echo '#!/bin/bash \n\n\
python ui.py \
"$@"' > /usr/bin/entrypoint.sh \
&& chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
