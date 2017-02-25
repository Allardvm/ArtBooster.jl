using Images
using ArtBooster

img = load(Pkg.dir("ArtBooster") * "/test/julia-logo.jpg")

param = Dict("max_depth" => 2,
             "eta" => 1.,
             "objective" => "reg:linear")

boostimage(img, param, iterations = 1, res_x = 200, res_y = 200)