LINCUBE_HOME=/s3i/Net-Protect
LINCUBE_BASE=$LINCUBE_HOME/www/WEB-INF
HOME_DIR=/s3i/Net-Protect/www/extModule
JAVA_PATH=/s3i/Net-Protect/java/bin/java

export LINCUBE_HOME LINCUBE_BASE HOME_DIR JAVA_PATH

LOGGING_CONFIG="-Dlog4j.configurationFile=$LINCUBE_BASE/log4j/log4j2_mimetype.xml"
export LOGGING_CONFIG

$JAVA_PATH -Dfile.encoding=UTF-8 -Xms1024m -Xmx1024m  $LIBRARY_CONFIG $LOGGING_CONFIG -jar $HOME_DIR/MimeCheck.jar $1