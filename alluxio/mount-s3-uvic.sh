#!/bin/sh

USAGE="Usage: ${0} <mount point> <address>"
USAGE_ENV="The \$AWS_ACCESS_KEY and \$AWS_SECRET_KEY must be set in the environment."

MOUNT_POINT=${1}
ADDRESS=${2}

if [ "${MOUNT_POINT}" = "" ]; then
  echo ""
  echo ${USAGE}
  echo ""
  exit -1
elif [ "${ADDRESS}" = "" ]; then
  echo ""
  echo ${USAGE}
  echo ""
  exit -1
elif [ "${AWS_ACCESS_KEY}" = "" ]; then
  echo ""
  echo ${USAGE_ENV}
  echo ""
  exit -1
elif [ "${AWS_SECRET_KEY}" = "" ]; then
  echo ""
  echo ${USAGE_ENV}
  echo ""
  exit -1
fi

generateJSON()
{
  cat <<EOD
{
"shared": true,
"properties": {
  "alluxio.underfs.s3.endpoint": "https://s3-uvic.dev.computecanada.ca", 
  "alluxio.underfs.s3.proxy.https.only":true, 
  "alluxio.underfs.s3a.signer.algorithm":"S3SignerType", 
  "alluxio.underfs.s3.disable.dns.buckets":true, 
  "aws.accessKeyId":"$AWS_ACCESS_KEY", 
  "aws.secretKey":"$AWS_SECRET_KEY"
}
}
EOD
}

echo "$(generateJSON)"
curl -v \
-H "Content-Type: application/json" \
-d "$(generateJSON)" \
"http://stortest3.cadc.dao.nrc.ca:39999/api/v1/paths/${MOUNT_POINT}/mount/?src=${ADDRESS}"

