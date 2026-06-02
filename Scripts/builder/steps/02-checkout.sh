#!/bin/bash -eux

PDFium_URL='https://pdfium.googlesource.com/pdfium.git'
OS=${PDFium_TARGET_OS:?}
ENABLE_V8=${PDFium_ENABLE_V8:-false}

CONFIG_ARGS=()
if [ "$ENABLE_V8" == "false" ]; then
  CONFIG_ARGS+=(
     --custom-var "checkout_configuration=minimal"
  )
fi

# Clone
gclient config --unmanaged "$PDFium_URL" "${CONFIG_ARGS[@]-}"
echo "target_os = [ '$OS' ]" >> .gclient


# Reset
for FOLDER in pdfium pdfium/build pdfium/third_party/libjpeg_turbo pdfium/base/allocator/partition_allocator; do
  if [ -e "$FOLDER" ]; then
    git -C $FOLDER reset --hard
    git -C $FOLDER clean -df
  fi
done

# Pinned pdfium revision (T19, 2026-06-02). The iOS patch
# (patches/ios/pdfium.patch) is authored against this exact tree; floating
# to origin/main rots the patch context and breaks the build. To bump:
# sync to a new sha, refresh the patch against it with `git diff`, then
# repin here. Override with PDFium_BRANCH=<sha-or-ref> for a one-off.
PDFium_REV="${PDFium_BRANCH:-5563ca558f6f55b6d26c6b5d6cc403bf04b181df}"
gclient sync -r "$PDFium_REV" --no-history --shallow

# simdutf fix (T19). At the pinned sha, testing/BUILD.gn references
# //third_party/simdutf unconditionally, but DEPS gates that dep on
# checkout_v8 (false under the minimal config), so gclient skips it. gn gen
# parses the (unbuilt) test targets, so simdutf must still be present.
# Patching DEPS + re-syncing doesn't work: `gclient sync -r` refuses a dirty
# tree and would reset the patch anyway. Instead fetch ONLY simdutf at its
# DEPS-pinned rev — lean (no V8/Skia), no gclient conflict. The reset/clean
# loop above drops it on re-runs, so the dir guard re-fetches each time.
# When bumping the pinned pdfium sha, simdutf_revision is read from DEPS
# automatically, so no manual rev bump needed here.
if [ ! -d pdfium/third_party/simdutf ]; then
  SIMDUTF_REV=$(python3 -c "import re;print(re.search(r\"'simdutf_revision':\s*'([0-9a-f]+)'\",open('pdfium/DEPS').read()).group(1))")
  git clone https://chromium.googlesource.com/chromium/src/third_party/simdutf pdfium/third_party/simdutf
  git -C pdfium/third_party/simdutf checkout -q "$SIMDUTF_REV"
fi