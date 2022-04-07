# ERStruct
A MATLAB toolbox for inferring the number of top informative PCs that capture population struture based on genotype information.

## Requirements for Data File
Data files must be of .mat format. The data matrix must with 0,1,2 and/or NaN (for missing values) entries only, the rows represent indivials and columns represent markers. If there are more than one data files, the data matrix inside must with the same number of rows. (Try spliting the data files into smaller ones if out of memory error occures)

## Examples
```
% Using the example data files inside the toolbox folder
ERStruct(2504, '.', ["test_chr21","test_chr22"], 10000, 1e-4)
```

## Othehr Details
Please refer to our paper
> *An Eigenvalue Ratio Approach to Inferring Population Structure from Whole Genome Sequencing Data*
