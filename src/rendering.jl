function initws(res_x::Int, res_y::Int)
    clearws()

    ds_width_meters, ds_height_meters, ds_width_px, ds_height_px = inqdspsize()
    ds_px_width_meters = ds_width_meters / ds_width_px
    ds_px_height_meters = ds_height_meters / ds_height_px
    ws_width_meters = res_x * ds_px_width_meters
    ws_height_meters = res_y * ds_px_height_meters

    setwsviewport(0., ws_width_meters, 0., ws_height_meters)
    setwswindow(0., 1., 0., 1.)
    setviewport(0., 1., 0., 1.)
    setwindow(0., 1., 0., 1.)

    updatews()
end


function render(gr_img::GRImage)
    clearws()
    drawimage(0., 1., 0., 1., gr_img.res_x, gr_img.res_y, gr_img.abgr, 0)
    updatews()
end
