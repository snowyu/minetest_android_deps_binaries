#!/bin/bash -e
######
# IMPORTANT: NDK r22 has broken zlib, use either r22b or r23*
ndk=$HOME/android-sdk-linux/ndk/22.1.7171670
#PROXY="-x socks5h://localhost:1081"
BOTAN_VERSION=2.18.1
BOTAN_URL=https://botan.randombit.net/releases/Botan-$BOTAN_VERSION.tar.xz
######

mkdir -p deps
[ -d deps/botan ] ||
[ -d deps/botan ] || { curl -C - ${PROXY} -L "${BOTAN_URL}" \
	| tar -xJ -C deps; mv deps/Botan-${BOTAN_VERSION} deps/botan; }

toolchain=$(echo "$ndk"/toolchains/llvm/prebuilt/*)
[ -d "$toolchain" ] || { echo "NDK path wrong"; exit 1; }
export PATH="$toolchain/bin:$ndk:$PATH"

abi=$1
if [ "$abi" == armeabi-v7a ]; then
  cpu=armv7-a
	apilvl=16
	gentriple=arm-linux-androideabi
	# export CC=armv7a-linux-androideabi$apilvl-clang
	CXX=armv7a-linux-androideabi$apilvl-clang++
elif [ "$abi" == arm64-v8a ]; then
  cpu=arm64
	apilvl=21
	gentriple=aarch64-linux-android
	# export CC=$gentriple$apilvl-clang
	CXX=$gentriple$apilvl-clang++
else
	echo "Invalid ABI given"; exit 1
fi

dest=$PWD/../Botan
mkdir -p $dest/clang/$abi
mkdir -p $dest/include

mkdir -p deps/botan/$abi
# pushd deps/botan/$abi
# CFLAGS="-fPIC" ../botan-runtime/configure --host=${CC%-*} --enable-static --disable-shared || exit 1
pushd deps/botan
params=""
if [ "$apilvl" -lt 18 ]; then
  params="--without-os-feature=getauxval"
fi
CFLAGS="-fPIC" ./configure.py $params --enable-static-library --disable-shared-library --os=android --cc=clang --cpu=${cpu} --cc-bin=$CXX --ar-command=${gentriple}-ar

make -j4

if [ -d "$dest" ]; then
  make DESTDIR=./$abi -s install || exit 1
	cp -fv $abi/usr/local/lib/*.a $dest/clang/$abi/
	rm -rf $dest/include
  srcinc=$(echo $abi/usr/local/include/*/*)
	cp -a $srcinc $dest/include
fi
popd

echo "Botan built successfully (for $abi, API$apilvl)."
exit 0


# TARGET_ABI=armeabi-v7a
# # TARGET_ABI = arm64-v8a

# mkdir -p ../Botan/clang/$TARGET_ABI
# cp ./deps/botan/build/usr/local/lib/* ../Botan/clang/$TARGET_ABI
# # cp -r ./deps/botan/build/usr/local/include ../Botan/

