# Genetic-algorithm-for-Si-AlN-Saphire-platform
Genetic algorithm for optimising Si-AlN-Saphire platform

This code runs automation process for the optimization of a Si-AlN-Saphire platform using Genetic Algorithm.

ga.m is the main function, which run the GA process

pattern_generate.m generates patterns according to the input parameters, the patterns are used for calculating FOM.

preset.m runs the pre-conditioning process, includes updating the Boundaries and domains when new patterns are generated.

pattern_remove.m removes the pattern once the calculation is completed.

Comsol and Matlab API is needed. 
