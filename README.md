# IntroToMPI

### Exercises for Intro to Distributed Memory Parallel Computing with MPI Workshop

This workshop is offered by the [National Center for Supercomputing Applications](https://www.ncsa.illinois.edu/).
Each exercise is comprised of a serial code (**/serial** folder), the MPI-parallelized version of it (**/solution** folder), and pseudo-code with comments/hints on how to parallelize it (**/hint#** folders). Makefiles are available for compilation with GCC. Exercises are implemented in C++ and Fortran, being identical except for the unavoidable syntax differences. In addition, there is always a **/yourwork** folder that you can use to play with the code and try out your directives. In that folder, you will find the base serial code to each exercise as a starting point (the same found in **/serial**).

## Getting a session on the Illinois Campus Cluster
During the workshop, you will be editing files, compiling code and, most importantly, **running** things. We don't want to do this in the system's login nodes (the place where you arrive to after logging in through XSEDE's SSO Hub). We want to grab a chunk of a compute node. Follow the steps below.

### Log in
Log in to ICC from your local terminal:
```
ssh -l <YourNetID> cc-login1.campuscluster.illinois.edu
```
  
You are now sitting on a login node on the Campus Cluster. 


### Clone this branch of the repository to get the exercises files
Load the `git` module using
```
module load git
```
and then clone this session's branch with

```
git clone --branch uiuc-icc --single-branch https://github.com/babreu-ncsa/IntroToMPI.git
```

You should be ready to go now! If you know how to get around with *git*, you can alternatively fork this repo and clone it from your account.


## Recommended usage
The main exercise presents an application that performs a Linear Regression through simple grid search. It is intended to be interactive: I really think it is important for you to try to insert your own MPI calls, compile and run the code before looking into the hints, and use the solution as your last resource. The way you approach this is totally flexible and you should do what you feel comfortable with. Below is my recommendation:

1. Take a look at the serial code and make sure you understand what it is doing. I inserted many comments that you may find useful.
2. Try to identify how you are going to perform domain decomposition. What will each process be doing? You may be able to go much beyond what I've done, so don't be shy.
3. Use the **/yourwork** area to write your parallelized version. 
4. Once you are done and are sure your code behaves as expected, check out one possible solution that I implemented in the **/solution** folder. You can also use this a last resource after you exhaust your attempts to parallelize the code.
5. Have a different solution? I want to know about it! Open a GitHub issue here and describe it! I will be happy to add that to this repo.

### yourwork space
If you are working on this from a remote server, I recommend cloning the entire repo and then using the **/yourwork** folders to work on the exercises. You can have that file open in your terminal using a text editor (vi, nano, emacs) and, if you want to check on the hints (or the solution), you can use your browser and look at the files on GitHub, as opposed to have yet another ssh session running (or even worse, having to close and open files every time).

## Compiling MPI code
There are several MPI distributions implemented by open-source communities and by vendors. Generally speaking, there shouldn't be much difference between them. If you are really looking to squeezing every single drop of performance out, it may be interesting to try different ones. Here, we will be using the Intel MPI compiler to compile our codes. The Intel MPI-C++ compiler is `mpiicc`, and the Intel MPI-Fortran compiler is `mpiifort`. On ICC, to use them, we need to load the following module:

```
module load intel/18.0
```

The compilation itself is exactly the same as if you were using your traditional compiler. For the C++ codes, you will need enable C++14 with the `-std=c++14` flag. For example, to compile the Hello World code, one possibility is:

```
mpiicc -std=c++14 hello_mpi.cpp -o hello_mpi.exe
```
or
```
mpiifort hello_mpi.cpp -o hello_mpi.exe
```

### Makefile
The workspace has a **Makefile** that takes the source code, which is named *ExerciseName_yourwork.<cpp/f90>* and compiles it into an executable *ExerciseName_yourwork.exe* (you will also get an object file that can be ignored). This Makefile already includes the MPI compiler call. However, you still need to load the Intel MPI module (see above).


## Running MPI applications
Once the code is compiled, we want to run it in parallel using several processes. To make that happen, we need to use an MPI wrapper that will make the binary generated in the compilation step be replicated to as many processes as we wish. Again, we will be using the Intel MPI implementation, and the wrapper is named `mpirun`. For instance, to run the Hello World application with 16 processes, you would do:

```
mpirun -n 16 ./hello_mpi.exe
```

Notice that, again, to use `mpirun` on ICC, the Intel MPI module needs to be loaded.

### Job scripts
We need to submit the MPI workload to ICC's batch scheduler. In each folder, you will find one or several of them. For the /yourwork area, you can run your code using the scripts that follow the nomeclature `ExerciseName_ywN.jobscript`. Here, $N$ is the number of processes to be used. We recommend you can the script with 8 processes to test your solution. However, if you are ready to collect results and see how your solution scales, a job array script is avaliable. The ExerciseName_yw_array.jobscript file will test your solution with 1, 2, 4, 8, 16, and 32 processes. You just need to submit that script once. To submit a script, use the sbatch command:

```
sbatch <scriptName>.jobscript
```

To check on the status of your runs, you can use:
```
squeue -u $USER
```


## Comments and Hints syntax
Comments that are sprinkled over the code files start with **//** for C++ and **!** for Fortran. Hints start with a **// !! HINT#** and finish with **!!** for C++, start with **! ## HINT#** and finish with **##** for Fortran. 

# Exercises

## [Hello](./Exercises/Hello)
The programming model for MPI is fundamentally different than shared memory parallel programming. Many copies of the same program are run concurrently, and MPI functions allow us to be specific about what we want each process to do. In this exercise, you will use the ubiquitous MPI functions `MPI_Init`, `MPI_Comm_rank`, and `MPI_Finalize` to make each process element print their ID.

## [LinearRegression](./Exercises/LinearRegression)
The MPI programming model requires you to redesign serial applications and perform domain decomposition of your problem to distribute the workload to all available processes. In this exercise, we will train a machine learning model from scratch using MPI. We will perform a linear regression on top of synthetic noisy data, finding the best set of parameters $(a,b)$ such that $y(x) = ax + b$ gives us the minimum mean squared error by performing a grid search across the parameter space. 

In contrast to previous exercises, the solution to this problem depends entirely on how you decide to perform domain decomposition. For that reason, no hints are provided. However, regardless of what you choose to do, it is likely that you will use the collective communication functions `MPI_Bcast` and `MPI_Reduce` to get the correct results. If you are unsure about how to use them, check on the [Examples](./Examples).

You can use this [suggest domain decomposition handout](https://docs.google.com/presentation/d/13skCf6Wf__cB0bbF1CIaZ_z1ZOQSDQ5KxKqCA9Q5XOo/edit?usp=sharing) to help you conceptualize how to break down your problem.

# Examples
Apart from [Exercises](./Exercises), this repository also has some [Examples](./Examples) of common MPI communication (point-to-point and collective) operations:
- [MPI_SEND and MPI_RECV](./Examples/SendRecv)
- [MPI_BCAST](./Examples/Bcast)
- [MPI_REDUCE](./Examples/Reduce)
