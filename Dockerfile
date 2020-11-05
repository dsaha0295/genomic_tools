# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV samtools_version 1.10
ENV bcftools_version 1.10
ENV htslib_version 1.10
ENV bedtools_version 2.29.2
ENV version 2.22.9
ENV PICARD /usr/local/bin/picard/picard.jar


# run update and install necessary packages
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnss-sss \
    libbz2-dev \
    liblzma-dev \
    vim \
    less \
    libcurl4-openssl-dev \
    wget \
    python \
    python-pip \
    curl \
    openjdk-8-jre 



# download the suite of tools
WORKDIR /usr/local/bin/
RUN wget https://github.com/samtools/samtools/releases/download/${samtools_version}/samtools-${samtools_version}.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/${bcftools_version}/bcftools-${bcftools_version}.tar.bz2
RUN wget https://github.com/samtools/htslib/releases/download/${htslib_version}/htslib-${htslib_version}.tar.bz2

# extract files for the suite of tools
RUN tar -xjf /usr/local/bin/samtools-${samtools_version}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/bcftools-${bcftools_version}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/htslib-${htslib_version}.tar.bz2 -C /usr/local/bin/

# run make on the source
RUN cd /usr/local/bin/htslib-${htslib_version}/ && ./configure
RUN cd /usr/local/bin/htslib-${htslib_version}/ && make
RUN cd /usr/local/bin/htslib-${htslib_version}/ && make install

RUN cd /usr/local/bin/samtools-${samtools_version}/ && ./configure
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make install

RUN cd /usr/local/bin/bcftools-${bcftools_version}/ && make
RUN cd /usr/local/bin/bcftools-${bcftools_version}/ && make install


# install bedtools
WORKDIR /usr/local/bin
RUN curl -SL https://github.com/arq5x/bedtools2/archive/v${bedtools_version}.tar.gz \
    > v${bedtools_version}.tar.gz
RUN tar -xzvf v${bedtools_version}.tar.gz
WORKDIR /usr/local/bin/bedtools2-${bedtools_version}
RUN make
RUN ln -s /usr/local/bin/bedtools2-${bedtools_version}/bin/bedtools /usr/local/bin/bedtools


# download picard tools and change permissions
RUN mkdir -p /usr/local/bin/picard \
    && curl -SL https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar \
    > /usr/local/bin/picard/picard.jar
RUN chmod 0644 /usr/local/bin/picard/picard.jar

