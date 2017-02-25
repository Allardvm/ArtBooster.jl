"""
    boostimage(img, param; [iterations = 1, res_x = 500, res_y = 500])

Turns an image into an abstract figure by predicting its features with a gradient booster.

# Arguments
* `img::Matrix{T<:AbstractRGB}`: the image to boost.
* `param::Dict`: a dictionary with the XGBoost parameters to use in the prediction.
* `iterations::Int`: keyword argument that sets the number of boosting iterations. Defaults to `1`.
* `res_x::Int`: keyword argument that sets the horizontal resolution of the rendered abstract
    figure. Defaults to `500`.
* `res_y::Int`: keyword argument that sets the vertical resolution of the rendered abstract figure.
    Defaults to `500`.
"""
function boostimage{T<:AbstractRGB}(img::Matrix{T}, param::Dict;
                                    iterations::Int = 1, res_x::Int = 500, res_y::Int = 500)
    println("Preparing data structures...")
    bst_img = BoostingImage(img)
    pred_img = BoostingImage(res_x, res_y, bst_img)
    gr_img = GRImage(res_x, res_y)


    X = hcat(bst_img.x, bst_img.y)
    data_r = DMatrix(X, label = bst_img.r; transposed = false)
    data_g = DMatrix(X, label = bst_img.g; transposed = false)
    data_b = DMatrix(X, label = bst_img.b; transposed = false)
    pred_coords = DMatrix(hcat(pred_img.x, pred_img.y); transposed = false)

    bst_r = xgboost(data_r, 0, param = param, metrics = ["rmse"])
    bst_g = xgboost(data_g, 0, param = param, metrics = ["rmse"])
    bst_b = xgboost(data_b, 0, param = param, metrics = ["rmse"])

    initws(res_x, res_y)
    for iter in 1:iterations
        println("[", iter, "]: training Red channel...")
        XGBoost.update(bst_r, data_r, 1)
        pred_img.r = predict(bst_r, pred_coords)

        println("[", iter, "]: training Green channel...")
        XGBoost.update(bst_g, data_g, 1)
        pred_img.g = predict(bst_g, pred_coords)

        println("[", iter, "]: training Blue channel...")
        XGBoost.update(bst_b, data_b, 1)
        pred_img.b = predict(bst_b, pred_coords)

        println("[", iter, "]: Rendering...")
        update!(gr_img, pred_img)
        render(gr_img)
    end

    return nothing
end
