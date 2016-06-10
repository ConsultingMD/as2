FROM ruby:2.1.5
MAINTAINER ops@grnds.com

WORKDIR /root
RUN apt-get update -y -qqq \
 && apt-get -y install vim
RUN gem install bundler
RUN git clone https://github.com/ConsultingMD/as2.git
WORKDIR /root/as2
RUN ./bin/setup
RUN echo hello world > test.txt
RUN echo "#!/bin/bash\nbundle exec ruby examples/client.rb test.txt" > client.sh \
 && chmod +x client.sh
RUN echo "#!/bin/bash\nbundle exec ruby examples/server.rb" > server.sh \
 && chmod +x server.sh
CMD ["/bin/bash"]
