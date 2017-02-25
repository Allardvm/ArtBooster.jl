ArtBooster.jl
========

[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)

**ArtBooster.jl** turns images into abstract figures by predicting their features with a gradient
booster. The package renders the booster's depiction of the image in real-time, using whatever
model hyperparameters the user provides. Fitting is done using the XGBoost package, which supports
Linux and Mac OS X.

# Installation
Add the package to Julia with:
```julia
Pkg.clone("https://github.com/Allardvm/ArtBooster.jl.git")
```

To test the package, use Julia's native package testing functions:
```julia
Pkg.test("ArtBooster")
```

# Getting started
```julia
using Images
using ArtBooster

img = load(Pkg.dir("ArtBooster") * "/test/julia-logo.jpg")

param = Dict("max_depth" => 2,
             "eta" => .5,
             "objective" => "reg:linear")

boostimage(img, param, iterations = 150, res_x = 1260, res_y = 852)
```
Resulting in:

![Abstract Julia logo](doc/julia-logo-abstract.jpg)

# Exports

## Functions

### `boostimage(img, param; [iterations = 1, res_x = 500, res_y = 500])`
Turns an image into an abstract figure by predicting its features with a gradient booster.

#### Arguments
* `img::Matrix{T<:AbstractRGB}`: the image to boost.
* `param::Dict`: a dictionary with the XGBoost parameters to use in the prediction.
* `iterations::Int`: keyword argument that sets the number of boosting iterations. Defaults to `1`.
* `res_x::Int`: keyword argument that sets the horizontal resolution of the rendered abstract
    figure. Defaults to `500`.
* `res_y::Int`: keyword argument that sets the vertical resolution of the rendered abstract figure.
    Defaults to `500`.
