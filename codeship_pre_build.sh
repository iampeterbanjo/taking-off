#!/bin/bash
# Install a custom Elixir version, http://elixir-lang.org/
#
ERLANG_VERSION=${ERLANG_VERSION:="19.0"}
ERLANG_PATH=${ERLANG_PATH:=$HOME/erlang}
CACHED_DOWNLOAD="${HOME}/cache/erlang-OTP-${ERLANG_VERSION}.tar.gz"
# no set -e because this file is sourced and with the option set a failing command
# would cause an infrastructure error message on Codeship.
mkdir -p "${ERLANG_PATH}"
ERLANG_PATH=$(realpath "${ERLANG_PATH}")
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://s3.amazonaws.com/heroku-buildpack-elixir/erlang/cedar-14/OTP-${ERLANG_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${ERLANG_PATH}"
"${ERLANG_PATH}/Install" -minimal "${ERLANG_PATH}"
export PATH="${ERLANG_PATH}/bin:${PATH}"
# check the correct version is yused
erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), erlang:display(erlang:binary_to_list(Version)), halt().' -noshell | grep "${ERLANG_VERSION}"
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * ELIXIR_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/elixir.sh)"
ELIXIR_VERSION=${ELIXIR_VERSION:="1.4.0"}
ELIXIR_PATH=${ELIXIR_PATH:=$HOME/elixir}
CACHED_DOWNLOAD="${HOME}/cache/elixir-v${ELIXIR_VERSION}.zip"
# no set -e because this file is sourced and with the option set a failing command
# would cause an infrastructure error message on Codeship.
mkdir -p "${ELIXIR_PATH}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://s3.amazonaws.com/s3.hex.pm/builds/elixir/v${ELIXIR_VERSION}.zip"
unzip -q -o "${CACHED_DOWNLOAD}" -d "${ELIXIR_PATH}"
export PATH="${ELIXIR_PATH}/bin:${PATH}"
# check the correct version is used
elixir --version | grep "${ELIXIR_VERSION}"
# Get dependencies
yes | mix deps.get
yes | mix local.rebar