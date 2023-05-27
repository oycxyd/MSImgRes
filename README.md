# MSImgRes
Automated Image Restoration for MSI data

**Installation**:

*MATLAB >= 2020 is needed for AutoDeconv

- AutoDeconv
Add the root folder to path and run AutoDeconv_demo.m for example code.

- GANUNET
1. create environment using the yml file included in the folder by e.g., conda env create -n imgres -f imgres.yml

2. download the trained weights and put into the GANUNET root folder (containing the GANUNET.ipynb file)

Links for trained weights:

- ESRGAN weights https://www.dropbox.com/s/0wj869qozq4hcxx/rrdn-C4-D3-G32-G032-T10-x4_best-val_generator_loss_epoch051.hdf5?dl=0

3. activate the environment (in this case, conda activate imgres) and run the GANUNET.ipynb script for example code

FAQ:
* what to do if I get error 'TypeError: Descriptors cannot not be created directly.'
This is related to the protobuf package and the suggested solution of downgrading to protobuf<=3.20 seems to work. Easiest way is pip install protobuf==3.20 --force-reinstall

* I get 'InvalidVersion: Invalid version: '2.2.4-tf'' when trying to load the weights
This is probably due to a conflict in tensorflow version required by CBSDEEP and ISR, easiest solution is: pip install tensorflow==3.10 --force-reinstall
(Note that some conflicts will be warned, but 2.10 has been tested to be stable thus far)
