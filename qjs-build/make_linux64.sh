mkdir -p build && cd build
cmake ../
cd ..
cmake --build build --config Release
mkdir -p ~/qjs/Lib/Linux64/
cp build/libquickjs.a ~/qjs/Lib/Linux64/ 
