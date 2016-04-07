#!/usr/bin/env bash -e

. gradle.properties

nextVersion=${version}
version=${version%*-SNAPSHOT}

echo "Starting release for logback-android ${version}..."

# gradle-release-plugin prompts for your Nexus credentials
# with "Please specify username" (no mention of Nexus).
# Use our own prompt to remind the user where they're
# logging into to.
read -p "Nexus username: " user
read -p "Nexus password: " -s pass
echo ''

./gradlew   -Pversion=${version}                \
            -PnexusUsername=${user}             \
            -PnexusPassword=${pass}             \
            -Ppush                              \
            clean                               \
            readme                              \
            release                             \
            uploadArchives                      \
            uberjar
#            uploadDocs                          \

hub release edit -d -m '' v_${version} -a build/logback-android-${version}.jar
