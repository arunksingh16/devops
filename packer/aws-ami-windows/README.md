# Windows AMI Build with Packer
This directory contains configuration files and scripts for building Windows AMIs using [Packer](https://www.packer.io/).

## Running the Packer Configuration

1. **Install Packer**  
    Ensure [Packer](https://www.packer.io/downloads) is installed on your system.

2. **Configure AWS Credentials**  
    Set up your AWS credentials using environment variables or the AWS CLI.

3. **Run the Build**  
    Execute the following command from this directory:
    ```sh
    packer build .
    ```