FROM rocker/r-ver:3.6.1

# install required version of renv
RUN R --quiet -e "install.packages('remotes', repos = 'https://cran.rstudio.com')"
# make sure version matches what is used in the project: packageVersion("renv")
ENV RENV_VERSION 0.8.3-81
RUN R --quiet -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /app

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends \
  libgdal-dev=2.1.2+dfsg-5 \
  libgeos-dev=3.5.1-3 \
  libudunits2-dev=2.2.20-1+b1 \
  libproj-dev=4.9.3-1 \
  && apt-get clean

COPY renv.lock .
RUN R --quiet -e "renv::restore()"

COPY geomarker_name.rds .
COPY geomarker_name.R .

WORKDIR /tmp

ENTRYPOINT ["/app/geomarker_name.R"]
