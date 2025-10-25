# ------------------------------------------------------------------------------
# Dockerfile for Paperspace Gradient
# Base: Official Paperspace PyTorch image with CUDA 12.1 (ideal for A6000)
# Purpose: Install latest paddlepaddle-gpu and paddleocr
# ------------------------------------------------------------------------------

# 1. Start from an official Paperspace base image.
# This is critical. These images are pre-configured with the correct CUDA
# libraries, Python, Jupyter environment, and directory structures
# (like /notebooks) that Gradient expects.
#
# We select a PyTorch image with CUDA 12.1, which is fully compatible
# with the A6000 (Ampere architecture).
FROM paperspace/pytorch:2.1.0-cuda12.1-py3.10

# 2. Switch to the root user to install system dependencies.
# The 'paperspace' user (the default) doesn't have sudo privileges.
USER root

# 3. Install system dependencies.
# paddleocr depends on opencv-python, which in turn depends on
# system libraries like libgl1 for image processing.
# The base image may already have this, but ensuring it is robust.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# 4. Upgrade pip and install the required Python packages.
# We install paddlepaddle-gpu first, which will detect the CUDA 12.1
# environment and install the correct GPU-compatible version.
# Then, we install paddleocr, which will use the paddlepaddle-gpu runtime.
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir paddlepaddle-gpu paddleocr

# 5. Switch back to the default 'paperspace' user.
# The base image is configured to launch the Jupyter notebook as this
# user. Failing to switch back will cause permission errors.
USER paperspace
