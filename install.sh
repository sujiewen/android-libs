#!/usr/bin/env bash
set -euo pipefail

GROUP_ID="${GROUP_ID:-com.github.sujiewen.android-libs}"
WORK_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="${WORK_DIR}/.jitpack-tmp"
RXLIFE_COROUTINE_FILE_VERSION="2.0.0"
RXLIFE_COROUTINE_PUBLISH_VERSION="2.0.0"
RXLIFE_RXJAVA_FILE_VERSION="3.0.0"
RXLIFE_RXJAVA_PUBLISH_VERSION="3.0.0"
RXANDROID_FILE_VERSION="3.0.0"
RXANDROID_PUBLISH_VERSION="3.0.0"
RXANDROID_ORIGINAL_VERSION="3.0.0"
RXJAVA_FILE_VERSION="3.0.3"
RXJAVA_PUBLISH_VERSION="3.0.3"
RXJAVA_ORIGINAL_VERSION="3.0.3"
RXHTTP_FILE_VERSION="2.3.5"
RXHTTP_PUBLISH_VERSION="2.3.5"
RXHTTP_ANNOTATION_FILE_VERSION="1.0.1"
RXHTTP_ANNOTATION_PUBLISH_VERSION="2.3.5"
RXHTTP_COMPILER_FILE_VERSION="2.3.5"
RXHTTP_COMPILER_PUBLISH_VERSION="2.3.5"

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

write_relocation() {
  local pom_file="$1"
  local group_id="$2"
  local artifact_id="$3"
  local version="$4"

  cat >> "${pom_file}" <<POM
  <distributionManagement>
    <relocation>
      <groupId>${group_id}</groupId>
      <artifactId>${artifact_id}</artifactId>
      <version>${version}</version>
    </relocation>
  </distributionManagement>
POM
}

write_rxlife_coroutine_pom() {
  local pom_file="$1"
  local version="$2"
  write_pom_start "${pom_file}" "rxlife-coroutine" "${version}" "aar" "rxlife-coroutine" "https://github.com/liujingxing/RxLife"
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
  local version="$2"
  write_pom_start "${pom_file}" "rxlife-rxjava" "${version}" "aar" "rxlife3" "https://github.com/liujingxing/RxLife"
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
  local version="$2"
  write_pom_start "${pom_file}" "rxandroid" "${version}" "aar" "RxAndroid" "https://github.com/ReactiveX/RxAndroid"
  write_relocation "${pom_file}" "io.reactivex.rxjava3" "rxandroid" "${RXANDROID_ORIGINAL_VERSION}"
  write_pom_end "${pom_file}"
}

write_rxjava_pom() {
  local pom_file="$1"
  local version="$2"
  write_pom_start "${pom_file}" "rxjava" "${version}" "jar" "RxJava" "https://github.com/ReactiveX/RxJava"
  write_relocation "${pom_file}" "io.reactivex.rxjava3" "rxjava" "${RXJAVA_ORIGINAL_VERSION}"
  write_pom_end "${pom_file}"
}

write_rxhttp_pom() {
  local pom_file="$1"
  local version="$2"
  write_pom_start "${pom_file}" "rxhttp" "${version}" "jar" "rxhttp2" "https://github.com/liujingxing/RxHttp"
  cat >> "${pom_file}" <<POM
  <dependencies>
    <dependency>
      <groupId>${GROUP_ID}</groupId>
      <artifactId>rxhttp-annotation</artifactId>
      <version>${RXHTTP_ANNOTATION_PUBLISH_VERSION}</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.8.5</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>org.jetbrains.kotlinx</groupId>
      <artifactId>kotlinx-coroutines-android</artifactId>
      <version>1.3.4</version>
      <scope>compile</scope>
    </dependency>
  </dependencies>
POM
  write_pom_end "${pom_file}"
}

write_rxhttp_annotation_pom() {
  local pom_file="$1"
  local version="$2"
  write_pom_start "${pom_file}" "rxhttp-annotation" "${version}" "jar" "rxhttp-annotation2" "https://github.com/liujingxing/RxHttp"
  write_pom_end "${pom_file}"
}

write_rxhttp_compiler_pom() {
  local pom_file="$1"
  local version="$2"
  write_pom_start "${pom_file}" "rxhttp-compiler" "${version}" "jar" "rxhttp-compiler" "https://github.com/liujingxing/RxHttp"
  cat >> "${pom_file}" <<POM
  <dependencies>
    <dependency>
      <groupId>com.squareup</groupId>
      <artifactId>javapoet</artifactId>
      <version>1.12.1</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>com.squareup</groupId>
      <artifactId>kotlinpoet</artifactId>
      <version>1.5.0</version>
      <scope>compile</scope>
    </dependency>
    <dependency>
      <groupId>${GROUP_ID}</groupId>
      <artifactId>rxhttp-annotation</artifactId>
      <version>${RXHTTP_ANNOTATION_PUBLISH_VERSION}</version>
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
  local publish_version="$2"
  local file_version="$3"
  local packaging="$4"
  local base_dir="$5"
  local writer="$6"
  local main_file="${base_dir}/${artifact_id}-${file_version}.${packaging}"
  local sources_file="${base_dir}/${artifact_id}-${file_version}-sources.jar"
  local javadoc_file="${base_dir}/${artifact_id}-${file_version}-javadoc.jar"
  local pom_file="${TMP_DIR}/${artifact_id}-${publish_version}.pom"
  local published_pom_file="${base_dir}/${artifact_id}-${file_version}.pom"

  "${writer}" "${pom_file}" "${publish_version}"
  cp "${pom_file}" "${published_pom_file}"
  install_main_artifact "${artifact_id}" "${publish_version}" "${packaging}" "${main_file}" "${pom_file}"
  install_classifier_artifact "${artifact_id}" "${publish_version}" "sources" "${sources_file}"
  install_classifier_artifact "${artifact_id}" "${publish_version}" "javadoc" "${javadoc_file}"
}

install_module "rxlife-coroutine" "${RXLIFE_COROUTINE_PUBLISH_VERSION}" "${RXLIFE_COROUTINE_FILE_VERSION}" "aar" "${WORK_DIR}/artifacts/rxlife-coroutine" "write_rxlife_coroutine_pom"
install_module "rxlife-rxjava" "${RXLIFE_RXJAVA_PUBLISH_VERSION}" "${RXLIFE_RXJAVA_FILE_VERSION}" "aar" "${WORK_DIR}/artifacts/rxlife-rxjava" "write_rxlife_rxjava_pom"
install_module "rxandroid" "${RXANDROID_PUBLISH_VERSION}" "${RXANDROID_FILE_VERSION}" "aar" "${WORK_DIR}/artifacts/rxandroid" "write_rxandroid_pom"
install_module "rxjava" "${RXJAVA_PUBLISH_VERSION}" "${RXJAVA_FILE_VERSION}" "jar" "${WORK_DIR}/artifacts/rxjava" "write_rxjava_pom"
install_module "rxhttp" "${RXHTTP_PUBLISH_VERSION}" "${RXHTTP_FILE_VERSION}" "jar" "${WORK_DIR}/artifacts/rxhttp" "write_rxhttp_pom"
install_module "rxhttp-annotation" "${RXHTTP_ANNOTATION_PUBLISH_VERSION}" "${RXHTTP_ANNOTATION_FILE_VERSION}" "jar" "${WORK_DIR}/artifacts/rxhttp-annotation" "write_rxhttp_annotation_pom"
install_module "rxhttp-compiler" "${RXHTTP_COMPILER_PUBLISH_VERSION}" "${RXHTTP_COMPILER_FILE_VERSION}" "jar" "${WORK_DIR}/artifacts/rxhttp-compiler" "write_rxhttp_compiler_pom"
