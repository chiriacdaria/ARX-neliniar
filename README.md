# :thought_balloon: ARX Nonlinear Model Identification

## Introduction 

To address this stage of the project, a basic understanding of linear ARX models is required, as covered in the course material in the ARX Methods section. The nonlinear ARX method is also explained in an annex of the same section.

A dataset measured from a dynamic system with input and output is provided. The system's order does not exceed 3, and its dynamics can be nonlinear, while the output can be affected by noise. We aim to develop a black-box model for this system using a nonlinear ARX structure in the form of a polynomial for input and output signals. A second dataset, measured from the same system, is provided for validating the developed model.

The datasets are provided in MATLAB files, in the variables "id" and "val," both being "iddata" objects from the systems identification toolbox. The input, output, and sampling period are available in the "u," "y," and "Ts" fields of these objects. In case the toolbox is not installed, the same datasets are provided in vector format, "id array" and "val array," each matrix having the structure: time values in the first column, input in the second, and output in the last column.

A nonlinear ARX model, with orders na, nb, and delay nk, using the same convention as the MATLAB "arx" function, has the structure:

​
 (k)=p(y(k−1),…,y(k−na),u(k−nk),u(k−nk−1),…,u(k−nk−nb+1))=p(d(k))

where the vector of delayed outputs and inputs is denoted as 
d(k)=[y(k−1),…,y(k−na),u(k−nk),u(k−nk−1),…,u(k−nk−nb+1)] '
p is a polynomial of degree m in these variables.

For example, if na=nb=nk=1, then d=[y(k−1),u(k−1)] ', and if we have degree m=2, we can explicitly write the polynomial:

y(k)=ay(k−1)+bu(k−1)+cy(k−1)^2+vu(k−1)^2+wu(k−1)y(k−1)+z

The parameters of the model, represented by a, b, c, v, w, z, are real coefficients. Note that the model is nonlinear and contains quadratic terms and products between delayed variables, unlike the standard ARX, which includes only linear terms in y(k−1) and u(k−1). An essential aspect of model (1) is that it is linear in parameters, meaning that the parameters can be found using linear regression.

It is noteworthy that the linear ARX form is a special case of the general form (1), obtained by choosing the degree m = 1, leading to:
 (k)=ay(k−1)+bu(k−1)+c
and, in addition, imposing the condition c=0 for the free term. Without this condition, the model is called affine.

## Requirements
For this stage, you need to program a function that generates a nonlinear ARX model of a polynomial type, with configurable orders na, nb, and degree m; nk can be left as 1. You should also program the regression procedure for parameter identification and the use of the model with new inputs. The use of this model can be done in two ways:

### Prediction (one step ahead): Using the real values of the delayed outputs of the system. In example (2), at step k, the equation (2) would be applied using the variables y(k−1) and u(k−1) on the right side of the equality.

### Simulation: Previous outputs of the system are not available, so only previous outputs of the model itself can be used. In this example, y(k−1) would be replaced with the simulated previous value (k−1) on the right side of equation (2).

Identify such a nonlinear ARX model using the identification dataset and validate it on the validation dataset. Pay attention to the model orders, as well as the polynomial degree, to achieve the best performance on the identification data. To simplify the search procedure, you can set na=nb.

## Structure Description
### Dataset
The datasets are provided in MATLAB files, and each contains time, input, and output values. The first 80% of the samples are used for identification, and the remaining 20% for validation.

## Nonlinear ARX Model
The nonlinear ARX model has a structure described by equation (1), which involves a polynomial of degree m and delayed input and output variables. The coefficients of the model, a, b, c, v, w, z, are real parameters.

### Model Identification
The identification process involves finding the optimal parameters for the nonlinear ARX model. The parameters are obtained using linear regression, as explained in the course material.

### Implementation
You need to implement a function that generates the nonlinear ARX model and another function for parameter identification. Additionally, implement the usage of the model for prediction and simulation.


# :speech_balloon: ARX Nonlinear Model Identification - Project Results

##Introduction
In this section, I present the results of the nonlinear ARX model identification project. The goal was to develop a black-box model for a dynamic system using a nonlinear ARX structure. The model's orders, polynomial degree, and parameters were identified and validated using provided datasets.

## Implementation Overview

### Dataset
The dataset was divided into an 80-20 split for identification and validation, respectively. It included time, input, and output values, crucial for training and evaluating the model.

### Nonlinear ARX Model
The model's structure followed equation (1), incorporating a polynomial of degree m and delayed input and output variables. The coefficients (a, b, c, v, w, z) were real parameters, and the model demonstrated nonlinear behavior, capturing quadratic terms and product interactions.

### Model Identification
The identification process involved generating the nonlinear ARX model and utilizing linear regression to find optimal parameters. Two modes of usage were implemented: prediction (one step ahead) and simulation. These modes allowed for assessing the model's performance under different conditions.


## Results and Evaluation

### Model Performance
The model's performance was evaluated based on Mean Squared Error (MSE) for both identification and validation datasets.

### Graphical Representation
The figures below illustrate the model's output compared to the real output for the best-performing configuration (na=nb=2, m=3) in both simulation and prediction modes.
