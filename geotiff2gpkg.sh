#!/bin/bash

# Directory containing GeoTIFF files
input_dir="./BGtopoVJ"
# Temporary VRT file
vrt_file="./BGtopoVJ_50k.vrt"
# Output GeoPackage file
output_file="./BGtopoVJ_50k.gpkg"

# Build VRT from GeoTIFF files
gdalbuildvrt $vrt_file $input_dir/*.tif

# Convert the VRT to a GeoPackage
gdal_translate -of GPKG $vrt_file $output_file

# Add overviews to the GeoPackage. 
# In GDAL overviews, the numbers (e.g., 2, 4, 8, ...) represent decimation factors that define the downsampling level for creating lower-resolution raster versions.
# You can add additional decimation factors 4096, 8192, etc. Higher numbers allow greater zoom-out and improve rendering speed.
# "nearest" can be changed to other resampling methods: nearest, average, bilinear, rms, etc.
gdaladdo -r nearest $output_file 2 4 8 16 32 64 128 256 512 1024 2048
echo "Conversion to ATAK GeoPackage completed: $output_file"
