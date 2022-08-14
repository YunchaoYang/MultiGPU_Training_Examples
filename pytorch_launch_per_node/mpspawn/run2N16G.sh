#!/bin/bash
#SBATCH --partition=hpg-ai

#SBATCH --time=08:00:00
#SBATCH --ntasks-per-node=1

#SBATCH --cpus-per-task=4

#SBATCH --mem-per-cpu=10000

#SBATCH --gres=gpu:a100:8

#SBATCH --nodes=2

#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err

module load gcc/9.3.0 cuda/11.4.3 pytorch/1.10
# source <virtual environment name>

# if some error happens in the initialation of parallel process then you can
# get the debug info. This can easily increase the size of out.txt.

#export NCCL_DEBUG=INFO  # comment it if you are not debugging distributed parallel setup
#export NCCL_DEBUG_SUBSYS=ALL # comment it if you are not debugging distributed parallel setup

# find the ip-address of one of the node. Treat it as master
ip1=`hostname -I | awk '{print $2}'`
echo $ip1

# Store the master node’s IP address in the MASTER_ADDR environment variable.
export MASTER_ADDR=$(hostname)

echo "r$SLURM_NODEID master: $MASTER_ADDR"

echo "r$SLURM_NODEID Launching python script"

srun python train.py --nodes 2 --ngpus 8 --ip_adress $ip1 --epochs 10
