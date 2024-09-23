#!/bin/zsh
cd Chamfer3D
# python setup.py install
pip install -e .
cd ../
echo "---- Chamfer3D--->Finish! ----"

cd pointnet2_ops_lib
# python setup.py install
pip install -e .
cd ../
echo "---- pointnet2_ops_lib--->Finish! ----"

cd pointops
# python setup.py install
pip install -e .
cd ../
echo "---- pointops--->Finish! ----"

# python setup.py install
pip install -e .