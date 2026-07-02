#!/usr/bin/env bash
set -euo pipefail

GROUP_ID="${GROUP_ID:-com.github.sujiewen.android-libs}"
WORK_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="${WORK_DIR}/.jitpack-tmp"

rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"
trap 'rm -rf "${TMP_DIR}"' EXIT

write_pom_start() {
  local pom_file="$1"
  local artifact_id="$2"
  local version="$3"
  local packaging="$4"
  local name="$5"
  local url="$6"

  cat > "${pom_file}" <<POM
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>${GROUP_ID}</groupId>
  <artifactId>${artifact_id}</artifactId>
  <version>${version}</version>
  <packaging>${packaging}</packaging>
  <name>${name}</name>
  <url>${url}</url>
  <licenses>
    <license>
      <name>The Apache Software License, Version 2.0</name>
      <url>http://www.apache.org/licenses/LICENSE-2.0.txt</url>
      <distribution>repo</distribution>
    </license>
  </licenses>
POM
}

write_pom_end() {
  local pom_file="$1"

  cat >> "${pom_file}" <<'POM'
</project>
POM
}

write_rxlife_coroutine_pom() {
  local pom_file="$1"
  write_pom_start "${pom_file}" "rxlife-coroutine" "2.0.0" "aar" "rxlife-coroutine" "https://github.com/liujingxing/RxLife"
  cat >> "${pom_file}" <<'POM'
  <dependencies>
    <dependency>
      <groupId>androidx.lifecycle</groupId>
      <artifactId>lifecycle-common</artifactId>
      <version>2.2.0</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.jetbrains.kotlin</groupId>
      <artifactId>kotlin-android-extensions-runtime</artifactId>
      <version>1.3.71</version>
      <scope>runtime</scope>
    </dependency>
  </dependencies>
POM
  write_pom_end "${pom_file}"
}

write_rxlife_rxjava_pom() {
  local pom_file="$1"
  write_pom_start "${pom_file}" "rxlife-rxjava" "3.0.0" "aar" "rxlife3" "https://github.com/liujingxing/RxLife"
  cat >> "${pom_file}" <<'POM'
  <dependencies>
    <dependency>
      <groupId>androidx.lifecycle</groupId>
      <artifactId>lifecycle-common</artifactId>
      <version>2.2.0</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.jetbrains.kotlin</groupId>
      <artifactId>kotlin-android-extensions-runtime</artifactId>
      <version>1.3.72</version>
      <scope>runtime</scope>
    </dependency>
  </dependencies>
POM
  write_pom_end "${pom_file}"
}

write_rxandroid_pom() {
  local pom_file="$1"
  write_pom_start "${pom_file}" "rxandroid" "3.0.0" "aar" "RxAndroid" "https://github.com/ReactiveX/RxAndroid"
  cat >> "${pom_file}" <<POM
  <dependencies>
    <dependency>
      <groupId>${GROUP_ID}</groupId>
      <artifactId>rxjava</artifactId>
      <version>3.0.3</version>
      <scope>compile</scope>
    </dependency>
  </dependencies>
POM
  write_pom_end "${pom_file}"
}

write_rxjava_pom() {
  local pom_file="$1"
  write_pom_start "${pom_file}" "rxjava" "3.0.3" "jar" "RxJava" "https://github.com/ReactiveX/RxJava"
  cat >> "${pom_file}" <<'POM'
  <dependencies>
    <dependency>
      <groupId>org.reactivestreams</groupId>
      <artifactId>reactive-streams</artifactId>
      <version>1.0.3</version>
      <scope>compile</scope>
    </dependency>
  </dependencies>
POM
  write_pom_end "${pom_file}"
}

install_main_artifact() {
  local artifact_id="$1"
  local version="$2"
  local packaging="$3"
  local artifact_file="$4"
  local pom_file="$5"

  mvn -q install:install-file \
    -Dfile="${artifact_file}" \
    -DpomFile="${pom_file}" \
    -Dpackaging="${packaging}"
}

install_classifier_artifact() {
  local artifact_id="$1"
  local version="$2"
  local classifier="$3"
  local artifact_file="$4"

  if [[ -f "${artifact_file}" ]]; then
    mvn -q install:install-file \
      -DgroupId="${GROUP_ID}" \
      -DartifactId="${artifact_id}" \
      -Dversion="${version}" \
      -Dfile="${artifact_file}" \
      -Dpackaging="jar" \
      -Dclassifier="${classifier}" \
      -DgeneratePom=false
  fi
}

install_module() {
  local artifact_id="$1"
  local version="$2"
  local packaging="$3"
  local base_dir="$4"
  local writer="$5"
  local main_file="${base_dir}/${artifact_id}-${version}.${packaging}"
  local sources_file="${base_dir}/${artifact_id}-${version}-sources.jar"
  local javadoc_file="${base_dir}/${artifact_id}-${version}-javadoc.jar"
  local pom_file="${TMP_DIR}/${artifact_id}-${version}.pom"

  "${writer}" "${pom_file}"
  install_main_artifact "${artifact_id}" "${version}" "${packaging}" "${main_file}" "${pom_file}"
  install_classifier_artifact "${artifact_id}" "${version}" "sources" "${sources_file}"
  install_classifier_artifact "${artifact_id}" "${version}" "javadoc" "${javadoc_file}"
}

install_module "rxlife-coroutine" "2.0.0" "aar" "${WORK_DIR}/artifacts/rxlife-coroutine" "write_rxlife_coroutine_pom"
install_module "rxlife-rxjava" "3.0.0" "aar" "${WORK_DIR}/artifacts/rxlife-rxjava" "write_rxlife_rxjava_pom"
install_module "rxandroid" "3.0.0" "aar" "${WORK_DIR}/artifacts/rxandroid" "write_rxandroid_pom"
install_module "rxjava" "3.0.3" "jar" "${WORK_DIR}/artifacts/rxjava" "write_rxjava_pom"
