

#Variables
name="praneeth"
s3_bucket="upgrad-praneeth"
timestamp=$(date '+%d%m%Y-%H%M%S')


sudo apt update -y

if [ apache2 == $(dpkg --get-selections apache2 | awk '{print $1}') ];

then

        echo "apache2 is installed"
else
       sudo apt install apache2 -y

fi


service_status=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')

if [ running == ${service_status} ];

then
      echo "service is runnig"
else

        systemctl start apache2

fi

service_enable=$(systemctl is-enabled apache2 | grep "enabled")

if [ enabled == ${service_enable} ];

then

       echo "service is ebabled"
else
        systemctl enable apache2

fi


cd /var/log/apache2

tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log


if [ -f /tmp/${name}-httpd-logs-${timestamp}.tar ];

then
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar

fi
