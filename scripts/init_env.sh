#!/usr/bin/env bash
set -euo pipefail

if [ -f ".env" ]; then
	echo ".env already exists"
	exit 0
fi

SOURCE_FILE=".env.template"
if [ ! -f "${SOURCE_FILE}" ]; then
	SOURCE_FILE=".env.example"
fi

cp "${SOURCE_FILE}" .env
echo "Provisioned .env from ${SOURCE_FILE}";
