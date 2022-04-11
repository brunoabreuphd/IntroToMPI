# IntroToMPI

### Exercises for Intro to Parallel Computing with MPI Workshop presented on 4/14/2022

This workshop is offered by the [National Center for Supercomputing Applications](https://www.ncsa.illinois.edu/).
Each exercise is comprised of a serial code (**/serial** folder), the MPI-parallelized version of it (**/solution** folder), and pseudo-code with comments/hints on how to parallelize it (**/hint#** folders). Makefiles are available for compilation with GCC. Exercises are implemented in C++ and Fortran, being identical except for the unavoidable syntax differences. In addition, there is always a **/yourwork** folder that you can use to play with the code and try out your directives. In that folder, you will find the base serial code to each exercise as a starting point (the same found in **/serial**).

## Getting a session on Expanse
During the workshop, you will be editing files, compiling code and, most importantly, **running** things. We don't want to do this in the system's login nodes (the place where you arrive to after logging in through XSEDE's SSO Hub). We want to grab a chunk of a compute node. Follow the steps below.

### Log in
1. Log in to XSEDE's SSO Hub from your local terminal:

    ```
    ssh -l <YourXSEDEUsername> login.xsede.org
    ```
2. Log in to SDSC's Expanse:


    ```
    gsissh expanse
    ```
  
You are now sitting on a login node in Expanse. 
  

### Grab a chunk of a compute node
Copy and paste the following command on your terminal to get 16 cores on a **compute** node:

```
srun --partition=shared --pty --account=nsa108 --nodes=1 --ntasks-per-node=1 --cpus-per-task=16 --mem=30G -t 02:00:00 --wait=0 --export=ALL /bin/bash
```


### Move to the project area and download the exercises source code
In addition to be using a compute node, we will also be using the **project** storage area of Expanse. Besides being the recommended place to always run your applications (**project** has faster access than **home** from the compute nodes), this will also allow members within the same project (all of us here) to read each other's files (not write to them!). Move from your **home** area to the **project** area with the command:

```
cd /expanse/lustre/projects/nsa108/<YourXSEDEUsername>
```

Now simply *git clone* this repository:

```
git clone https://github.com/babreu-ncsa/IntroToOpenMP.git
```

You should be ready to go now! If you know how to get around with *git*, you can alternatively fork this repo and clone it from your account.
