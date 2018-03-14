FROM debian
ENV DISPLAY :0
RUN apt-get update && apt-get install -y tk git
RUN git clone https://github.com/phil294/tkbash
COPY guibuilder.sh .
RUN ln -s /tkbash/tkbash /bin
CMD ./guibuilder.sh