FROM ubuntu:14.04
MAINTAINER Anthony Bradley
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential python-dev python-numpy git python-setuptools vim flex bison cmake sqlite3 libsqlite3-dev libboost-dev openbabel libboost-python-dev libboost-regex-dev python-matplotlib python-openbabel python-pip nginx libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev unzip
RUN easy_install ipython Django==1.5.0 tornado
RUN pip install gunicorn django-jfu
RUN apt-get install -y python-psycopg2
RUN mkdir /RDKit && cd /RDKit && git clone https://github.com/rdkit/rdkit.git
ADD bashrc /root/.bashrc
ADD make_rdkit.bash /make_rdkit.bash
RUN /bin/bash make_rdkit.bash
ADD me /me
RUN mkdir /CHOC && git clone https://abradley@bitbucket.org/abradley/cocoa.git /CHOC && cd /CHOC && git checkout dev
ADD run_gunicorn.bash /run_gunicorn.bash
ADD personalsettings.py /CHOC/src/WebApp/WebApp/personalsettings.py
ADD WONKA_db /CHOC/src/WebApp/data/WONKA_db
RUN pip install south
RUN mkdir /CHOC/logs/
ADD nginx.conf /etc/nginx/sites-available/Cocoa
RUN pip install djutils
RUN apt-get install -y python-scipy
RUN ln -s /etc/nginx/sites-available/Cocoa /etc/nginx/sites-enabled/Cocoa
RUN rm /etc/nginx/sites-enabled/default
RUN python /CHOC/src/WebApp/djangorun.py collectstatic --noinput
CMD service nginx restart && bash /run_gunicorn.bash
