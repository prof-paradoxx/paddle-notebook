# ------------------------------------------------------------------------------
# Dockerfile for Paperspace Gradient
# Base: Official Paperspace PyTorch image with CUDA 12.1 (ideal for A6000)
# Purpose: Install latest paddlepaddle-gpu and paddleocr
# ------------------------------------------------------------------------------

# 1. Start from an official Paperspace base image.
# This one is PyTorch-specific and much smaller than the "gradient-base"
FROM paperspace/pytorch:2.3.0-cuda12.1-py3.10-notebook

# 2. Switch to the root user to install system dependencies.
USER root

# 3. Install system dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# 4. Upgrade pip and install the required Python packages.
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir paddlepaddle-gpu paddleocr

# 5. Switch back to the default 'paperspace' user.
USER paperspace
