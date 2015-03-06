#!/bin/bash
NAME="Cocoa"                                  # Name of the application
DJANGODIR=/CHOC/src/WebApp        # Django project directory
SOCKFILE=/CHOC/src/WebApp/run/gunicorn.sock  # we will communicte using this unix socket
USER=root                                      # the user to run as
GROUP=root                                    # the group to run as
NUM_WORKERS=5                                    # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=WebApp.wsgisettings             # which settings file should Django use
DJANGO_WSGI_MODULE=WebApp.wsgi                     # WSGI module name
TIMEOUT=60
echo "Starting $NAME as `whoami`"

cd $DJANGODIR
# Activate the environment
export RDBASE=/RDKit/rdkit
export LD_LIBRARY_PATH=$RDBASE/lib:$LD_LIBRARY_PATH
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH:$RDBASE:$RDBASE/lib

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --log-level=debug \
  --bind=unix:$SOCKFILE\
  --timeout $TIMEOUT
