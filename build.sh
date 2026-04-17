#!/bin/bash
set -euo pipefail
yarn install --frozen-lockfile
git clone git@github.com:StarRocks/starrocks.git temp
npm run copy
export DOCUSAURUS_IGNORE_SSG_WARNINGS=true
export NODE_OPTIONS="--max-old-space-size=8192"
export DOCUSAURUS_SSR_CONCURRENCY=8
export DOCUSAURUS_PERF_LOGGER=true
yarn clear
rm -rf build

VERSION_STRING="['4.1', '4.0', '3.5', '3.4', '3.3', '3.2', '3.1']"
VERSIONS=$(echo $VERSION_STRING | tr -d "[]'," )

for DOC_VERSION_TO_BUILD in $VERSIONS
do
    # Define a unique directory for this specific version
    OUT_DIR="./build/version-$DOC_VERSION_TO_BUILD"

    echo "🚀 Building version $DOC_VERSION_TO_BUILD into $OUT_DIR..."
    
    # Passing both the version and the output directory
    export DOC_VERSION_TO_BUILD=$DOC_VERSION_TO_BUILD
    yarn build --out-dir="$OUT_DIR"
    
    if [ $? -ne 0 ]; then
        echo "❌ Build failed for $VERSION"
        exit 1
    fi
done

echo "✅ All builds complete. Check the ./build folder!"
