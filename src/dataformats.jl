type BoostingImage
    x::Vector{Float32}
    y::Vector{Float32}
    r::Vector{Float32}
    g::Vector{Float32}
    b::Vector{Float32}
    res_x::Int
    res_y::Int


    function BoostingImage{T<:AbstractRGB}(img::Matrix{T})
        rows, cols = size(img)
        lin_size = rows * cols
        x = Vector{Float32}(lin_size)
        y = Vector{Float32}(lin_size)
        r = Vector{Float32}(lin_size)
        g = Vector{Float32}(lin_size)
        b = Vector{Float32}(lin_size)

        @inbounds for col in 1:cols
            for row in 1:rows
                lin_idx = row + ((col - 1) * rows)
                x[lin_idx] = convert(Float32, row)
                y[lin_idx] = convert(Float32, col)
                r[lin_idx] = convert(Float32, img[row, col].r) * 255f0
                g[lin_idx] = convert(Float32, img[row, col].g) * 255f0
                b[lin_idx] = convert(Float32, img[row, col].b) * 255f0
            end
        end

        return new(x, y, r, g, b, rows, cols)
    end


    function BoostingImage(res_x::Int, res_y::Int, img::BoostingImage)
        lin_size = res_y * res_x
        x_scale = img.res_x / res_x
        y_scale = img.res_y / res_y
        x = Vector{Float32}(lin_size)
        y = Vector{Float32}(lin_size)
        r = Vector{Float32}(lin_size)
        g = Vector{Float32}(lin_size)
        b = Vector{Float32}(lin_size)

        lin_idx = 1
        @inbounds for y_idx in 1:res_y
            for x_idx in 1:res_x
                x[lin_idx] = convert(Float32, x_idx * x_scale)
                y[lin_idx] = convert(Float32, y_idx * y_scale)
                lin_idx += 1
            end
        end

        return new(x, y, r, g, b, res_x, res_y)
    end
end


type GRImage
    abgr::Vector{UInt32}
    res_x::Int
    res_y::Int

    GRImage(res_x::Int, res_y::Int) = new(fill(0xff000000, res_x * res_y), res_x, res_y)
end


function update!(gr_img::GRImage, bst_img::BoostingImage)
    @assert gr_img.res_x == bst_img.res_x
    @assert gr_img.res_y == bst_img.res_y

    abgr = gr_img.abgr
    lin_size = gr_img.res_x * gr_img.res_y
    @inbounds @simd for lin_idx in 1:lin_size
        abgr[lin_idx] = 0xff000000
    end

    r = bst_img.r
    g = bst_img.g
    b = bst_img.b
    abgr = gr_img.abgr
    @inbounds for lin_idx in 1:lin_size
        abgr[lin_idx] += round(UInt32, min(255f0, max(0f0, b[lin_idx]))) << 16
        abgr[lin_idx] += round(UInt32, min(255f0, max(0f0, g[lin_idx]))) << 8
        abgr[lin_idx] += round(UInt32, min(255f0, max(0f0, r[lin_idx])))
    end

    return nothing
end
