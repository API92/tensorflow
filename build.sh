bazel build --config=monolithic --define no_gcp_support=true --define no_hdfs_support=true --define no_aws_support=true -c opt --copt="-DIS_MOBILE_PLATFORM" --copt="-DTFLITE_IS_MOBILE_PLATFORM" --copt="-ffunction-sections" --copt="-fdata-sections"  --copt="-march=core-avx2" //custom:libtensorflow-lite.so
