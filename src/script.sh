#!/bin/bash
set +e

LINTER_NAME="actionlint"
ACTIONLINT_PARAMS=()
ACTIONLINT_FILE_PATERN=()
ACTIONLINT_VERSION="${ACTIONLINT_VERSION:-latest}"
ACTIONLINT_CONFIG_FILE="${ACTIONLINT_CONFIG_FILE:-}"

read -r -a ACTIONLINT_FILE_PATERN <<< "${FILE_PATTERN:-}"

# Check if actionlint is installed
if [[ ! -f "./actionlint" ]]; then
  echo "::group:: Installing actionlint ..."
  bash <(curl https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash)
  echo "::endgroup::"
fi

# Check if config files exists
if [[ -n "${ACTIONLINT_CONFIG_FILE}" ]]; then
  if [[ ! -f "${ACTIONLINT_CONFIG_FILE}" ]]; then
    echo "::error title=${LINTER_NAME}::Config file not found: ${ACTIONLINT_CONFIG_FILE}"
    exit 1
  else
    ACTIONLINT_PARAMS+=( "--config-file" "${ACTIONLINT_CONFIG_FILE}" )
  fi
fi

# Run actionlint
echo "::group::📝 Running actionlint ..."
./actionlint --color "${ACTIONLINT_PARAMS[@]}" "${ACTIONLINT_FILE_PATERN[@]}"
actionlint_exit_code=$?
echo "::endgroup::"

exit "${actionlint_exit_code}"
