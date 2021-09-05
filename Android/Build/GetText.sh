#!/bin/bash -e
######
# IMPORTANT: NDK r22 has broken zlib, use either r22b or r23*
ndk=$HOME/android-sdk-linux/ndk/22.1.7171670
#PROXY="-x socks5h://localhost:1081"
GETTEXT_VERSION=0.21
GETTEXT_URL=https://ftp.gnu.org/pub/gnu/gettext/gettext-$GETTEXT_VERSION.tar.gz
######

mkdir -p deps
[ -d deps/gettext ] ||
[ -d deps/gettext ] || { curl -C - ${PROXY} -L "${GETTEXT_URL}" \
	| tar -xz -C deps; mv deps/gettext-${GETTEXT_VERSION} deps/gettext; }

toolchain=$(echo "$ndk"/toolchains/llvm/prebuilt/*)
[ -d "$toolchain" ] || { echo "NDK path wrong"; exit 1; }
export PATH="$toolchain/bin:$ndk:$PATH"

abi=$1
if [ "$abi" == armeabi-v7a ]; then
	apilvl=16
	gentriple=arm-linux-androideabi
	export CC=armv7a-linux-androideabi$apilvl-clang
elif [ "$abi" == arm64-v8a ]; then
	apilvl=21
	gentriple=aarch64-linux-android
	export CC=$gentriple$apilvl-clang
else
	echo "Invalid ABI given"; exit 1
fi

TARGET_CFLAGS_ADDON="-Ofast -fvisibility=hidden -fexceptions -D__ANDROID_API__=${apilvl}"
TARGET_CXXFLAGS_ADDON="${TARGET_CFLAGS_ADDON} -frtti"
export CFLAGS="${CFLAGS} ${TARGET_CFLAGS_ADDON}"
export CPPFLAGS="${CPPFLAGS} ${TARGET_CXXFLAGS_ADDON} -fPIC"

dest=$PWD/../GetText
mkdir -p $dest/clang/$abi
mkdir -p $dest/include

mkdir -p deps/gettext/$abi
pushd deps/gettext/$abi
../gettext-runtime/configure --host=${CC%-*} --enable-static --disable-shared || exit 1
make -j4

if [ -d "$dest" ]; then
  make DESTDIR=$PWD -s install || exit 1
	cp -fv usr/local/lib/*.a $dest/clang/$abi/
	rm -rf $dest/include
	cp -a usr/local/include $dest/include
fi
popd

echo "GetText built successfully (for $abi, API$apilvl)."
exit 0


# TARGET_ABI=armeabi-v7a
# # TARGET_ABI = arm64-v8a

# mkdir -p ../GetText/clang/$TARGET_ABI
# cp ./deps/gettext/build/usr/local/lib/* ../GetText/clang/$TARGET_ABI
# # cp -r ./deps/gettext/build/usr/local/include ../GetText/

