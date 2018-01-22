#!/bin/bash

echo "Test: Running run.sh script"

export PATH=/opt/Qt/5.3/gcc_64/bin:$PATH

cd /cartabuild/CARTAvis/carta/html5/common/skel

./generate.py source-all > /dev/null

cd /cartabuild/CARTAvis/

mkdir build

cd build

qmake NOSERVER=1 CARTA_BUILD_TYPE=dev ../carta -r

make -j 4

echo "Packaging now"
#svn export https://github.com/CARTAvis/deploytask/trunk/final_centos7_packaging_steps.sh
#chmod 755 final_centos7_packaging_steps.sh && ./final_centos7_packaging_steps.sh

#Temporarily copying and pasting the script here with modified paths for testing:

# 0. Define the installed location of your Qt 5.3 and CARTA source code (for grabing the latest html):
CARTABUILDHOME=/cartabuild/CARTAvis
qtpath=/opt/Qt/5.3/gcc_64                               ## location of your Qt installation
casapath=/cartabuild/CARTAvis-externals/ThirdParty/casa ## location of casacore/code installation
cartapath=/cartabuild/CARTAvis                          ## location of your CARTA source code
thirdparty=/cartabuild/CARTAvis-externals/ThirdParty    ## location where qooxdoo is installed 
packagepath=/tmp/carta
version=7.7.7                                           ## version number to be put on the final package

# 1. Export the location of the successfully built casacore/casacode library files
export LD_LIBRARY_PATH=$casapath/trunk/linux/lib


# 2. Download and run the latest make-app-carta script using the 'carta-distro' template
svn export https://github.com/CARTAvis/deploytask/trunk/make-app-carta
chmod 755 make-app-carta
rm -rf $packagepath-$version
svn export https://github.com/CARTAvis/deploytask/trunk/carta-distro
./make-app-carta -ni -v version=$version out=/tmp ws=$CARTABUILDHOME/build/cpp/desktop template=carta-distro


# 3. Fix a few things
cp -r $qtpath/plugins/platforms $packagepath-$version/bin/

cp $qtpath/lib/libQt5DBus.so.5 $packagepath-$version/lib/

chrpath -c -r '$ORIGIN/../lib:$ORIGIN/../plugins/CasaImageLoader' $packagepath-$version/plugins/ImageStatistics/libplugin.so

cp $thirdparty/cfitsio/lib/libcfitsio.so.5 $packagepath-$version/lib/

rm -f $packagepath-$version/include/python2.7

# 4. Copy over the html and qooxdoo
cp -r $cartapath/carta/html5 $packagepath-$version/etc
rm  $packagepath-$version/etc/html5/common/qooxdoo-3.5-sdk
cp -r $thirdparty/qooxdoo-3.5-sdk $packagepath-$version/etc/html5/common/qooxdoo-3.5-sdk

rm -f $packagepath-$version/etc/html5/html5.iml
rm -f $packagepath-$version/etc/html5/._html5.iml
rm -f $packagepath-$version/etc/html5/.idea

# 5. Setup geodetic and ephemerides data
curl -O -L http://www.asiaa.sinica.edu.tw/~ajm/carta/measures_data.tar.gz
tar -xvf measures_data.tar.gz
mv measures_data $packagepath-$version/etc/
rm measures_data.tar.gz


# 6. Copy over the sample images
curl -O -L http://www.asiaa.sinica.edu.tw/~ajm/carta/images.tar.gz
tar -xvf images.tar.gz
mkdir $packagepath-$version/etc/images
mv images $packagepath-$version/etc/
rm images.tar.gz


# 7. Fix for QtSql; copy the library file to the correct location
mkdir $packagepath-$version/bin/sqldrivers
cp $qtpath/plugins/sqldrivers/libqsqlite.so $packagepath-$version/bin/sqldrivers


#Finished

echo "Checking if built"

cd /tmp

ls -sort

tar -czvf carta-centos7-test.tar.gz carta-7.7.7

mv carta-centos7-test.tar.gz /cartabuild/CARTAvis/build

cd /cartabuild/CARTAvis/build

ls

