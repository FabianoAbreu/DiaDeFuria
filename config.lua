--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
        content = {
            graphicsCompatibility = 1,
            width = 1080, 
            height = 1920,
            scale = "zoomEven",
            fps = 60,

            imageSuffix = 
            {
                ["@15x"] = 1.5,
			    ["@2x"] = 2.1,
            },
        },
}
