# MSImgRes
## Automated Image Restoration for MSI data
## https://doi.org/10.3390/metabo13050669

**Installation**:

*MATLAB >= 2020 is needed for AutoDeconv

- AutoDeconv

Add the AutoDeconv folder and its content to path and run AutoDeconv_demo.m for example code.

- GANUNET
1. create environment using the yml file included in the folder by e.g., _conda env create -n imgres -f imgres.yml_

2. download the trained weights and put into the GANUNET root folder (containing the GANUNET.ipynb file)

Link for trained weights:

- ESRGAN weights https://www.dropbox.com/s/0wj869qozq4hcxx/rrdn-C4-D3-G32-G032-T10-x4_best-val_generator_loss_epoch051.hdf5?dl=0

3. activate the environment (in this case, _conda activate imgres_) and run the GANUNET.ipynb script in Jupyter (Notebook/Lab) for example code

**FAQ:**
* what to do if I get error 'TypeError: Descriptors cannot not be created directly.'
This is related to the protobuf package and the suggested solution of downgrading to protobuf<=3.20 seems to work. Easiest way is _pip install protobuf==3.20 --force-reinstall_

* I get 'InvalidVersion: Invalid version: '2.2.4-tf'' when trying to load the weights
This is probably due to a conflict in tensorflow version required by CBSDEEP and ISR, easiest solution is: _pip install tensorflow==2.10 --force-reinstall_
(Note that some conflicts will be warned, but 2.10 has been tested to be stable thus far)
