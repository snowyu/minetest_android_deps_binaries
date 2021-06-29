TARGET_ABI=armeabi-v7a
# TARGET_ABI = arm64-v8a

mkdir -p ../GetText/clang/$TARGET_ABI
cp ./deps/gettext/build/usr/local/lib/* ../GetText/clang/$TARGET_ABI
# cp -r ./deps/gettext/build/usr/local/include ../GetText/

