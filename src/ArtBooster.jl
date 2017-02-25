__precompile__()

module ArtBooster

using GR
using XGBoost
using Images

include("dataformats.jl")
include("boosting.jl")
include("rendering.jl")

export boostimage

end # module ArtBooster
