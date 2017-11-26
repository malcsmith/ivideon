#!/bin/bash

# Set the timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install iVideon if necessary
if [ ! -f "/etc/init.d/videoserverd_ctl" ]; then

    echo ""
    echo "Installing iVideon server, this might take a while.."
    echo ""

    # Sleep for a few seconds to let the user see the message above
    sleep 3

#    apt-get update -qq && apt-get install -qqy ivideon-server
        apt-get update -qq && apt-get install -y ivideon-server-headless

fi

# Start iVideon server with or without the web interface
if [ "${ENABLE_WEB_INTERFACE,,}" = "true" ]; then
    echo ""
    echo "Starting iVideon server with the web interface ENABLED.."
    echo ""

    # Start the necessary services
    /etc/init.d/apache2 start
    /etc/init.d/nettop_setup_ctl start
    /etc/init.d/videoserverd_ctl start

     # Show the user how to access the container
    echo ""
    echo "iVideon server should now be accessible at the following url:"
    echo "http://<CONTAINER_IP_OR_HOST>:80"
    echo ""

    # Keep the container running
    tail -f /opt/ivideon/videoserverd/daemon.log
else
    echo ""
    echo "Starting iVideon server with the web interface DISABLED.."
    echo ""

    # Stop the necessary services
    /etc/init.d/apache2 stop
    /etc/init.d/nettop_setup_ctl stop
    /etc/init.d/videoserverd_ctl stop

    # Start the iVideon server directly from the binary
    /opt/ivideon/videoserverd/videoserverd
fi