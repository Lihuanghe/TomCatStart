#!/bin/sh
# Better OS/400 detection: see Bugzilla 31132
os400=false
case "`uname`" in
OS400*) os400=true;;
esac

# resolve links - $0 may be a softlink
PWD=`pwd`
PRG="$PWD/$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=`dirname "$PRG"`
EXECUTABLE="../tomcat/bin/startup.sh"

# Check that target executable exists
if $os400; then
  # -x will Only work on the os400 if the files are:
  # 1. owned by the user
  # 2. owned by the PRIMARY group of the user
  # this will not work if the user belongs in secondary groups
  eval
else
  if [ ! -x "$PRGDIR"/"$EXECUTABLE" ]; then
    echo "Cannot find $PRGDIR/$EXECUTABLE"
    echo "The file is absent or does not have execute permission"
    echo "This file is needed to run this program"
    exit 1
  fi
fi

TOMCATINSTANCE=$1

if [ -z "$TOMCATINSTANCE" ];
then
        echo "should input the Deploy Dir Name."
        exit 1;
fi

DEPLOYHOME="$PRGDIR/../deploy"

DEPLOYPATH=`ls -1 $DEPLOYHOME | grep $TOMCATINSTANCE`

if [ -z "$DEPLOYPATH" ];
then
        echo "the Deploy Dir Name $TOMCATINSTANCE dost not exists in dictionary $DEPLOYHOME ."
        exit 1;
fi

for one in $DEPLOYPATH ; do
export CATALINA_BASE="$DEPLOYHOME/${one}"
"$PRGDIR"/"$EXECUTABLE"
done